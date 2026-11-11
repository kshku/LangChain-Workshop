// Shared helpers for the session notes.

// Point to a demo file and show how to run it.
// path: the demo file (for example "src/02-tools/tools.ipynb")
// run:  the command or instruction, as raw("...") or [markup]
#let demo(path, run) = [
  *Demo code:* #raw(path) \
  *Running:* #run
]
