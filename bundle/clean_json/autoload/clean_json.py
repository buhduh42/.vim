import vim
import json

def doIt():
  try:
    mode = vim.eval('visualmode()')
    if mode != "V":
      exit()
    start = int(vim.eval('line("\'<")'))
    stop = int(vim.eval('line("\'>")'))
    buff = ""
    for i in range(start, stop + 1):
      buff += vim.eval("getline('"+str(i)+"')")
  except:
    return

  try:
    obj = json.loads(buff)
  except ValueError, e:
    print e
    return
  out = json.dumps(obj, indent=1)
  for i in range(start, stop + 1):
    vim.command("d")
  lines = out.split("\n")
  vim.current.buffer.append(lines, start - 1)
  lastLine = str(start + len(lines))
  if vim.eval("getline('"+lastLine+"')") == "":
    vim.command(lastLine+"d")
doIt()
