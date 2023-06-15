# Change the ridiculous yellow errors to red
# https://github.com/ipython/ipython/pull/13756
from IPython.core.ultratb import VerboseTB
VerboseTB._tb_highlight = "bg:#ff5555"
