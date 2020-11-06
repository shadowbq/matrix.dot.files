from pygments.lexer import RegexLexer, words
from pygments.token import *

class CustomLexer(RegexLexer):
    name = 'custom'
    tokens = {
        'root': [
            (r'->', Operator),
            (r' ', Literal),
            (r'\./[^ ]*', Name.Class , '#pop'),
            (r'[a-zA-Z0-9//_/.]+', Name.Constant),
        ],
    }    
