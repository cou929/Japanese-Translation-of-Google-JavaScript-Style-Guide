#!/usr/bin/env python
# -*- coding: utf-8 -*-

import MeCab
import sys

mecab = MeCab.Tagger('-Ochasen')
result = {}
linenum = 0

for line in sys.stdin:
    linenum += 1
    iter = mecab.parseToNode(line)
    while iter:
        if iter.surface:
            surface = iter.surface
            pos = iter.feature.split(',')[0]
            reading = iter.feature.split(',')[-2]
            if pos != '記号' and reading != '*':
                key = (reading, pos)
                if key not in result:
                    result[key] = {}
                if surface in result[key]:
                    result[key][surface].append(linenum)
                else:
                    result[key][surface] = [linenum]
        iter = iter.next

for (k, v) in result.iteritems():
    (reading, pos) = (k[0], k[1])
    if len(v) > 1:
        counts = ', '.join(map(lambda key: '%s (%d)' % (key,
                           len(v[key])), list(v.keys())))
        linenums = '\t'.join(map(lambda key: '%s: %s' % (key,
                             ', '.join(str(x) for x in v[key])),
                             list(v.keys())))
        print '%s\t%s\t%s' % (reading, counts, linenums)
