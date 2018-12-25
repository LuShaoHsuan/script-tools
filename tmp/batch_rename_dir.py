import os
import re
list(map(lambda x: os.rename(x, re.sub('\d+_', '', x, 1)), os.listdir()))