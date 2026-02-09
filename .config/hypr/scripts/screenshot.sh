#!/bin/bash
# Zrzut zaznaczonego obszaru i edycja w swappy
grim -g "$(slurp)" - | swappy -f -
