import vim
import re
import copy
class VimController:
  @staticmethod
  def getWordUnderCursor():
    return vim.eval('expand("<cword>")')
  @staticmethod
  def getLineUnderCursor():
    return vim.eval('getline(".")')
  @staticmethod
  def getTotalLines():
    return int(vim.eval('line("$")'))
  #warning this tuple is indeced starting at 1,
  #the logic contained herein works in the usual 0 index manner
  @staticmethod
  def getCursorPosition(): #returns (col, row)
    cw = vim.current.window
    return cw.cursor
  @staticmethod
  #warning buffers are indeced at 0, unlike cursor position at 1
  def getRawStringofLine(row):
    cb = vim.current.buffer
    return cb[row]
  @staticmethod
  def moveCursor(row, col):
    cw = vim.current.window
    cw.cursor = (col + 1, row)
class Parser:
  forwardSymbols = ["def", "module", "do", "class", "while", "if"]
  backSymbols = ["end"]
  def __init__(self):
    self.direction = None
    self.position = None
    self.word = None
    rawLine = VimController.getLineUnderCursor()
    #TODO I should be checking to see if im in a comment too
    if self.isStartingInStr(rawLine):
      return
    self.totalLines = VimController.getTotalLines()
    self.currentLineNumber = VimController.getCursorPosition()[0] - 1
    word = VimController.getWordUnderCursor()
    #TODO heredocs fail
    if word in Parser.forwardSymbols:
      self.direction = "forward"
      self.reverse = False
      self.line = Line(rawLine, self.reverse)
    elif word in Parser.backSymbols:
      self.direction = "back"
      self.reverse = True
      self.line = Line(rawLine, self.reverse)
    else:
      return
    token = self.line.getToken((VimController.getCursorPosition())[1])
    self.stack = [True]
    #this is the first run, so I only care about stuff after/before the 
    #found token
    for idx, t in enumerate(self.line.tokens):
      if t == token:
        if idx == len(self.line.tokens) - 1:
          self.line = None
        else:
          #"jump" one token ahead, dont care about the first token
          self.line.tokens = self.line.tokens[idx + 1:]
          break
  def isStartingInStr(self, line):
    reIter = re.finditer(r"(['\"])(?:[^\1\\]|\\.)*?\1", line)
    groups = [(m.start(), m.end()) for m in reIter]
    pos = (VimController.getCursorPosition())[1]
    return len(filter(lambda g: g[0] < pos and g[1] > pos, groups)) > 0
  def processLine(self):
    if self.line is None:
      self.line = self.getNextLine()
    if self.line is None:
      return False
    for t in self.line.tokens:
      if t.type == "open":
        self.stack.append(True)
        continue
      else:
        self.stack.pop()
      if len(self.stack) == 0:
        VimController.moveCursor(t.start, self.currentLineNumber)
        return False
    #never got next line, still need to return true
    return True
  def getNextLine(self):
    if self.direction == "forward":
      step = 1
    else:
      step = -1
    while not (self.currentLineNumber == 0 or self.currentLineNumber == self.totalLines):
      self.currentLineNumber += step
      rawLine = VimController.getRawStringofLine(self.currentLineNumber)
      line = Line(rawLine, self.reverse)
      if len(line.tokens) > 0:
        return line      
    return None
#I have a line of gibberish, each applicaple symbol needs a starting col, 
#ending col, and a reference to the index of the list of applicable symbols
class Line:
  fRegExOr = '|'.join(Parser.forwardSymbols)
  bRegExOr = '|'.join(Parser.backSymbols)
  def __init__(self, line, reverse):
    self.line = line
    o = "open"
    c = "close"
    #if reversed, "closing" tokens should be "opening" tokens
    if reverse:
      o = "close"
      c = "open"
    #don't do comments if first character is #
    if re.search(r'^\s*#', self.line):
      self.tokens = []
      return
    reIter = re.finditer(r'\b('+Line.fRegExOr+r')\b', self.line)
    self.tokens = [self.TokenData(m, o) for m in reIter]
    reIter = re.finditer(r'\b('+Line.bRegExOr+r')\b', self.line)
    self.tokens += [self.TokenData(m, c) for m in reIter]
    self.removeStrings()
    self.removeTrailingComments()
    self.checkForFunkyIfs()
    self.tokens.sort(lambda f, s: f.start - s.start, None, reverse)
  #don't analyze lines with form: statement if exp
  def checkForFunkyIfs(self):
    found = re.findall(r'(?:(?!\bif\b).+?)(\bif\b)(?:(?!\bif\b).+?)', self.line.strip())
    #if should be the only token found
    if len(found) == 1 and len(self.tokens) == 1 and self.tokens[0].word == "if":
      self.tokens = []
  def removeTrailingComments(self):
    hashes = re.finditer("#", self.line)
    #this regex will break if different style quotes are used as string
    #delimitters on the same line, probably an edge case and shitty code anyway
    strRanges = re.finditer(r"(['\"])(?:[^\1\\]|\\.)*?\1", self.line)
    ranges = [(m.start(), m.end()) for m in strRanges]
    hLocations = [m.start() for m in hashes]
    for r in ranges:
      if len(hLocations) == 0:
        break
      hLocations = filter(lambda h: h not in range(r[0], r[1]), hLocations)
    if len(hLocations) > 0:
      self.line = self.line[:hLocations[0]]
      self.tokens = filter(lambda t: t.start < hLocations[0], self.tokens)
  def removeStrings(self):
    toRemove = []
    for t in self.tokens:
      #may cause a performance hit but iterables are weird
      #if necessary will need to do this smarter, the "tee" module may
      #reset iterators
      reIter = re.finditer(r"(['\"])(?:[^\1\\]|\\.)*?\1", self.line)
      for m in reIter:
        if (t.start > m.start() and t.start < m.end()):
          toRemove.append(t)
    for r in toRemove:
      self.tokens.remove(r)
  def getToken(self, col):
    for idx, t in enumerate(self.tokens):
      if col >= t.start and col <= t.stop:
        return self.tokens[idx]
    return None
  def __str__(self):
    return "\n".join([str(t) for t in self.tokens])

  #start and stop are inclusive indeces
  class TokenData:
    def __init__(self, match, type):
      self.start = match.start()
      self.stop = match.end() - 1
      self.word = match.group(1)
      self.type = type
    def __str__(self):
      return "(" + ", ".join((self.word, self.type, str(self.start), str(self.stop))) + ")"
class StupidBrackets:
  def __init__(self):
    self.parser = Parser() 
  def run(self):
    if self.parser.direction is None:
      return
    while self.parser.processLine():
      self.parser.line = self.parser.getNextLine()
try:
  stupidBrackets = StupidBrackets()
  stupidBrackets.run()
#don't spit out a bunch of gibberish to vim
except:
  pass
