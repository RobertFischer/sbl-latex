%% sbl.bst [2010/12/10]
%% Copyright 2008-2010 David Purton
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is David Purton.
% http://marshwiggle.net/sbllatex/

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    cited
    dictionarytitle
    shorttitle
    shortjournal
    shortdictionarytitle
    shortbooktitle
    shortseries
    translator
    url
    withauthor
    volumes
    lexicontitle
    shortlexicontitle
    volumetitle
    shortvolumetitle
    volumeeditor
    abbreviation
    translatedfrom
    lexiconkey
    introtype
    bookauthor
    origaddress
    origpublisher
    origyear
    longform
    shortform
    bibform
  }
  {}
  { label bysame }

INTEGERS { output.state before.all mid.sentence after.sentence after.block ed a b }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {mult}
{
  'a := %% we store the first value
  'b := %% we store the second value
  b #0 < %% We remember the sign of b, and
    { #-1 #0 b - 'b := } %% then consider its absolute value.
    { #1 } %%
  if$ %%
  #0 %% Put 0 on the stack.
  { b #0 > } %% While b is strictly positive,
    { %% we add a to the value on the stack
      a + %% and decrement b.
      b #1 - 'b := %%
    } %%
  while$ %%
  swap$ %% Last, we take the opposite
    'skip$ %% if b was negative.
    { #0 swap$ - } %%
  if$ %%
}

FUNCTION {chr.to.value} %% The ASCII code of a character
{
  chr.to.int$ #48 - %% ASCII value of "0" -> 48
  duplicate$ duplicate$ %% "1" -> 49
  #0 < swap$ #9 > or %% ...
    { %% "9" -> 57
      pop$ #0 %%
    }
    { }
  if$
}

FUNCTION {str.to.int.aux} %% The auxiliary function
{
  { duplicate$ empty$ not } %% While the string is not empty
    { %% consider its first char
      swap$ #10 mult 'a := %% and "add" it at the end of
      duplicate$ #1 #1 substring$ %% the result.
      chr.to.value a +
      swap$
      #2 global.max$ substring$
    }
  while$
  pop$
}

FUNCTION {str.to.int}
{ %% Handling negative values
  duplicate$ #1 #1 substring$ "-" =
    { #1 swap$ #2 global.max$ substring$ }
    { #0 swap$ }
  if$
  %% Initialization, and then
  #0 swap$ str.to.int.aux %% call to the aux. funtion
  swap$
    { #0 swap$ - } %% And handle the sign.
    { }
  if$
}

FUNCTION {at.end.of.sentence}
{
  duplicate$
  { #2 global.max$ substring$ duplicate$ text.length$ #1 > }
    { }
  while$
  "?" =
    { #1 }
    {
      duplicate$ "!" =
        { #1 }
        {
          duplicate$ "." = 
            { #1 }
            { #0 }
          if$
        }
      if$
    }
  if$
}

FUNCTION {enquote}
{
  duplicate$ empty$
    { pop$ "" }
    {
      "\begintitle{}" swap$ *
      at.end.of.sentence
        { "\protect\sblendquote{}" * }
        { 
          volume empty$
            { "\protect\endtitle{}" * }
            {
              type$ "incollection" =
              type$ "inbook" = or
                {
                  volumetitle empty$
                    { "\protect\endtitle{}" * }
                    { "\protect\volendtitle{}" * }
                  if$
                }
                { 
                  type$ "article" =
                  type$ "lexicon" = or
                    { "\protect\endtitle{}" * }
                    { "\protect\volendtitle{}" * }
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
}

FUNCTION {enquote.bib}
{
  duplicate$ empty$
    { pop$ "" }
    {
      "\begintitle{}" swap$ *
      at.end.of.sentence
        { "\protect\sblendquote{}" * }
        { "\protect\endbibtitle{}" * }
      if$
    }
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {make.shorttitle}
{
  % cut off subtitle at :
  #1 'a :=
    {
      duplicate$ a #1 substring$ ":" =
        { #0 }
        { 
          duplicate$ text.length$ a <
            { #0 }
            { #1 }
          if$
        }
      if$
    }
    { a #1 + 'a := }
  while$
  a #1 - 'a :=
  a text.prefix$
  % remove The, An, A prefix
  duplicate$ #4 text.prefix$ "The " =
    { #5 global.max$ substring$ }
    { }
  if$
  duplicate$ #3 text.prefix$ "An " =
    { #4 global.max$ substring$ }
    { }
  if$
  duplicate$ #2 text.prefix$ "A " =
    { #3 global.max$ substring$ }
    { }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names.first}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  numnames #3 >
    {
      s nameptr "{ff }{vv~}{ll}{~jj}" format.name$ 't :=
      t " et~al." *
    }
    {
      { namesleft #0 > }
        { 
          s nameptr "{ff }{vv~}{ll}{~jj}" format.name$ 't := 
          nameptr #1 >
            { 
              namesleft #1 >
                { ", " * t * }
                { 
                  numnames #2 >
                    { "," * }
                    'skip$
                  if$
                  t "others" =
                    { " et~al." * }
                    { " and " * t * }
                  if$
                }
              if$
            }
            't
          if$
          nameptr #1 + 'nameptr :=          % nameptr += 1;
          namesleft #1 - 'namesleft :=      % namesleft =- 1;
        }
      while$
    }
  if$
}

FUNCTION {format.names.firstfull}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  { namesleft #0 > }
    { 
      s nameptr "{ff }{vv~}{ll}{~jj}" format.name$ 't := 
      nameptr #1 >
        { 
          namesleft #1 >
            { ", " * t * }
            { 
              numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=          % nameptr += 1;
      namesleft #1 - 'namesleft :=      % namesleft =- 1;
    }
  while$
}

% LastName, FirstName
FUNCTION {format.names.last}
{ 's :=
  #1 'nameptr :=               % nameptr = 1;
  s num.names$ 'numnames :=    % numnames = num.name$(s);
  numnames 'namesleft :=
  { namesleft #0 > }
    {
      nameptr #1 =
        {s nameptr "{ll}{, ff}{ vv}{, jj}" format.name$ 't := }
        {s nameptr "{ff }{vv~}{ll}{~jj}" format.name$ 't := }
      if$
      nameptr #1 >
        { 
          namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=          % nameptr += 1;
      namesleft #1 - 'namesleft :=      % namesleft =- 1;
    }
  while$
}

FUNCTION {format.names.lastonly}
{ 's :=
  #1 'nameptr :=               % nameptr = 1;
  s num.names$ 'numnames :=    % numnames = num.name$(s);
  numnames 'namesleft :=
  numnames #3 >
    {
      s nameptr "{vv~}{ll}" format.name$ 't :=
      t " et~al." *
    }
    {
        { namesleft #0 > }
        { 
          s nameptr "{vv~}{ll}" format.name$ 't := 
          nameptr #1 >
            { 
              namesleft #1 >
                { ", " * t * }
                { 
                  numnames #2 >
                    { "," * }
                    'skip$
                  if$
                  t "others" =
                    { " et~al." * }
                    { " and " * t * }
                  if$
                }
              if$
            }
            't
          if$
          nameptr #1 + 'nameptr :=          % nameptr += 1;
          namesleft #1 - 'namesleft :=      % namesleft =- 1;
        }
      while$
    }
  if$
}

FUNCTION {format.edition}
{
  edition str.to.int 'ed :=
  ed #0 =
    { edition "~ed." * }
    {
      ed #2 =
        { "2d~ed." }
        {
          ed #3 =
            { "3d~ed." }
            { edition "th~ed." * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
	'year
	{ month " " * year * }
      if$
    }
  if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

% Functions to format and output the author (or editor if author is empty)
FUNCTION {format.author.firstref}
{
  author empty$
    { 
      s num.names$ 'numnames :=
      volumeeditor empty$
        { editor format.names.first }
        { volumeeditor format.names.first }
      if$
      numnames #1 >
        { ", eds." * }
        { ", ed." * }
      if$
    }
    { author format.names.first }
  if$
}

FUNCTION {format.author.subseqref}
{
  author empty$
    {
      volumeeditor empty$
        { editor format.names.lastonly }
        { volumeeditor format.names.lastonly }
      if$
    }
    { author format.names.lastonly }
  if$
}

FUNCTION {format.author.bib}
{
  author empty$
    {
      s num.names$ 'numnames :=
      volumeeditor empty$
        {
          editor empty$
            { "" }
            {
              bysame "\bysame" =
                { "\bysame" }
                { editor format.names.last }
              if$
            }
          if$
        }
        {
          bysame "\bysame" =
            { "\bysame" }
            { volumeeditor format.names.last }
          if$
        }
      if$
      numnames #1 >
        { ", eds." * }
        { ", ed." * }
      if$
    }
    { 
      bysame "\bysame" =
        { "\bysame" }
        { author format.names.last }
      if$      
      withauthor empty$
        { }
        { ", with " * withauthor format.names.firstfull * }
      if$
    }
  if$
}

% Function to output the shorttitle or title, if shorttitle is empty
% Similarly for shortbooktitle, shortdictionarytitle, shortjournal, 
% shortlexicon, shortvolumetitle
FUNCTION {format.shorttitle}
{
  shorttitle empty$
    { title make.shorttitle }
    { shorttitle }
  if$
}
FUNCTION {format.shortbooktitle}
{
  shortbooktitle empty$
    { booktitle make.shorttitle }
    { shortbooktitle }
  if$
}
FUNCTION {format.shortdictionarytitle}
{
  shortdictionarytitle empty$
    { dictionarytitle make.shorttitle }
    { shortdictionarytitle }
  if$
}
FUNCTION {format.shortlexicontitle}
{
  shortlexicontitle empty$
    { lexicontitle make.shorttitle }
    { shortlexicontitle }
  if$
}
FUNCTION {format.shortjournal}
{
  shortjournal empty$
    { journal make.shorttitle }
    { shortjournal }
  if$
}
FUNCTION {format.shortvolumetitle}
{
  shortvolumetitle empty$
    { volumetitle make.shorttitle }
    { shortvolumetitle }
  if$
}

% Functions to output series and shortseries (including number) if not empty
FUNCTION {format.series}
{
  series empty$
    { "" }
    { series
      number empty$
        { }
        { "~" * number * }
      if$
    }
  if$
}
FUNCTION {format.shortseries}
{
  shortseries empty$
    { format.series }
    { 
      shortseries
      number empty$
        { }
        { "~" * number * }
      if$
    }
  if$
}

FUNCTION {format.editor.translator.actual}
{
  translator empty$
    { 
      "ed.\ " editor format.names.first * "; " * write$
    }
    { 
      editor translator =
        { 
          "trans.\ and ed.\ " editor format.names.first * "; " * write$
        }
        { 
          "ed.\ " editor format.names.first * "; " * write$
          "trans.\ " translator format.names.first * "; " * write$
        }
      if$
    }
  if$
}

FUNCTION {format.editor.translator}
{
  editor empty$
    {
      translator empty$
        { }
        { "trans.\ " translator format.names.first * "; " * write$ }
      if$
    }
    {
      author empty$ type$ "incollection" = not and % sometimes no author wanted
        { 
          volumeeditor empty$
            {
              translator empty$
                { }
                { "trans.\ " translator format.names.first * "; " * write$ }
              if$
            }
            { 
              format.editor.translator.actual
            }
          if$
        }
        { 
          format.editor.translator.actual
        }
      if$
    }
  if$
}


FUNCTION {format.translator.bib}
{
  translator empty$
    { }
    {
      "Translated"
      translatedfrom empty$
        { }
        { " from " * translatedfrom * }
      if$
      " by " * translator format.names.firstfull * output
      new.block
    }
  if$
}

FUNCTION {format.editor.translator.actual.bib}
{
  translator empty$
    { 
      "Edited by " editor format.names.firstfull * output
      new.block
    }
    { 
      editor translator =
        { 
          "Translated and edited by " editor format.names.firstfull * output
          new.block
        }
        { 
          "Edited by " editor format.names.firstfull * output
          new.block
          format.translator.bib
        }
      if$
    }
  if$
}

FUNCTION {format.editor.translator.bib}
{
  editor empty$
    { format.translator.bib }
    {
      author empty$
        { 
          volumeeditor empty$
            { format.translator.bib }
            {
              format.editor.translator.actual.bib
            }
          if$
        }
        {
          format.editor.translator.actual.bib 
        }
      if$
    }
  if$
}

FUNCTION {output.origpubdetails}
{
  origaddress empty$
    { }
    { origaddress ": " * origpublisher * ", " * write$ }
  if$
  origyear empty$
    { }
    { origyear "; repr., " * write$ }
  if$
}

FUNCTION {output.origpubdetails.bib}
{
  origaddress empty$
    { }
    { 
      origaddress ": " * origpublisher * output
      origyear empty$
        { new.block }
        { }
      if$
    }
  if$
  origyear empty$
    { }
    { origyear ". Repr." * output }
  if$
}

FUNCTION {article.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  format.shortjournal emphasize write$
  volume empty$
    { }
    { 
      " " volume * write$
      number empty$
        { }
        { ", no.~" number * write$ }
      if$
    }
  if$
  " ("
  month empty$
    { "" * }
    { month * " " * }
  if$  
  year * "): " * write$
  pages n.dashify 
  url empty$
    { }
    { add.period$ " Cited " * cited * ". Online: \protect\url{" * url * "}" * }
  if$
  "}{%" * write$
  newline$
  author format.names.lastonly ", " * write$
  format.shorttitle enquote write$
  "}{%" write$
  newline$
  "article}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {book.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  format.author.firstref ", " * write$
  volumetitle empty$
    { title emphasize " " * write$ }
    { volumetitle emphasize " " * write$ }
  if$
  "(" write$
  volumetitle empty$
    { }
    { "vol.~" volume * " of " * title emphasize * "; " * write$ }
  if$
  format.editor.translator
  volumes empty$
    { }
    {
      volumes "~vols.; " * write$
    }
  if$
  edition empty$
    { }
    {
      format.edition "l" change.case$ "; " * write$
    }
  if$
  format.shortseries empty$
    { }
    {
      format.shortseries "; " * write$
    }
  if$
  output.origpubdetails
  address ": " * publisher * ", " * year * ")" * write$
  url empty$
    { }
    { ". Cited " cited * ". Online: \protect\url{" * url * "}" * write$ }
  if$  
  "}{%" write$
  newline$
  abbreviation empty$
    {
      format.author.subseqref ", " * write$
      volumetitle empty$
        { format.shorttitle emphasize write$ }
        { format.shortvolumetitle emphasize write$ }
      if$
    }
    { abbreviation write$ }
  if$
  "}{%" write$
  newline$
  "book}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {dictionary.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  format.shortdictionarytitle emphasize " " * write$
  volume empty$
    { }
    { volume ":" * write$ }
  if$
  pages n.dashify "}{%" * write$
  newline$
  author format.names.lastonly ", " * write$
  format.shorttitle enquote write$
  volume empty$
    { }
    { " \hbox{" volume * "}" * write$ } % use an hbox for future lastbox
  if$
  "}{%" write$
  newline$
  "dictionary}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {introduction.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  format.author.firstref ", " * write$
  introtype "l" change.case$ " to " * write$
  volumetitle empty$
    { title emphasize write$ }
    { volumetitle emphasize write$ }
  if$
  ", by " bookauthor format.names.first * " " * write$
  "(" write$
  volumetitle empty$
    { }
    { "vol.~" volume * " of " * title emphasize * "; " * write$ }
  if$
  format.editor.translator
  volumes empty$
    { }
    {
      volumes "~vols.; " * write$
    }
  if$
  edition empty$
    { }
    {
      format.edition "l" change.case$ "; " * write$
    }
  if$
  format.shortseries empty$
    { }
    {
      format.shortseries "; " * write$
    }
  if$
  output.origpubdetails
  address ": " * publisher * ", " * year * ")}{%" * write$
  newline$
  abbreviation empty$
    {
      format.author.subseqref ", " * write$
      introtype "t" change.case$ enquote write$
    }
    { abbreviation write$ }
  if$
  "}{%" write$
  newline$
  "introduction}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {lexicon.output.item}
{ newline$
  "\sblbibnoitem{%" write$
  newline$
  lexiconkey "}{%" * write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  format.shortlexicontitle emphasize write$
  volume empty$
    { ", " write$ }
    { " " volume * ":" * write$ }
  if$
  pages n.dashify "}{%" * write$
  newline$
  author format.names.lastonly ", " * write$
  format.shortlexicontitle emphasize write$
  volume empty$
    { }
    { " \hbox{" volume * "}" * write$ } % use an hbox for future lastbox
  if$
  "}{%" write$
  newline$
  "lexicon}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {incollection.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author empty$
    { }
    { author format.names.first ", " * write$ }
  if$
  title enquote " " * write$
  volumetitle empty$
    { "in " format.shortbooktitle emphasize * " (" * write$ }
    { 
      "in " volumetitle emphasize * " (" * write$
      volumeeditor empty$
        { }
        { "ed.\ " volumeeditor format.names.first * "; " * write$ }
      if$
      "vol.~" volume * " of " * booktitle emphasize * ", " * write$
    }
  if$
  format.editor.translator
  edition empty$
    { }
    {
      format.edition "l" change.case$ "; " * write$
    }
  if$
  format.shortseries empty$
    { }
    {
      format.shortseries "; " * write$
    }
  if$
  output.origpubdetails
  address ": " * publisher * ", " * year * ")" * write$
  ", " pages n.dashify * "}{%" * write$
  newline$
  author empty$
    { }
    { author format.names.lastonly ", " * write$ }
  if$
  format.shorttitle enquote write$
  volumetitle empty$
    { }
    {
      " in " format.shortvolumetitle emphasize * write$
      volumeeditor empty$
        {
          editor empty$
            { }
            { " (ed.\ " editor format.names.lastonly * ")" * write$ }
          if$
        }
        { " (ed.\ " volumeeditor format.names.lastonly * ")" * write$ }
      if$
      ", \hbox{" volume * "}" * write$
    }
  if$
  "}{%" write$
  newline$
  "incollection}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {online.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  "n.p.\ [cited " cited * write$
  "]. Online: \protect\url{" url * "}" * write$
  "}{%" write$
  newline$
  author format.names.lastonly ", " * write$
  format.shorttitle enquote write$
  "}{%" write$
  newline$
  "online}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {onlinemedia.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  format.series ", " * write$
  " " publisher * write$
  " [cited " cited * write$
  "]. Online: " howpublished * write$
  " \protect\url{" url * "}" * write$
  "}{%" write$
  newline$
  author format.names.lastonly ", " * write$
  format.shorttitle enquote write$
  " " format.series * write$
  "}{%" write$
  newline$
  "online}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {phdthesis.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  "(Ph.D.\ diss., " school * ", " * year * ")" * write$
  "}{%" write$
  newline$
  author format.names.lastonly ", " * write$
  format.shorttitle enquote write$
  "}{%" write$
  newline$
  "phdthesis}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {mastersthesis.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  author format.names.first ", " * write$
  title enquote " " * write$
  "(Masters diss., " school * ", " * year * ")" * write$
  "}{%" write$
  newline$
  author format.names.lastonly ", " * write$
  format.shorttitle enquote write$
  "}{%" write$
  newline$
  "mastersthesis}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {misc.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  longform write$
  "}{%" write$
  newline$
  shortform write$
  "}{%" write$
  newline$
  "misc}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {father.output.item}
{ newline$
  author empty$
    {
      "\sblbibnoitem{}{%" write$
      newline$
      title emphasize
      "}{%" * write$
      newline$
      title emphasize
    }
    {
      "\sblbibitem{%" write$
      newline$
      author format.names.first ", " * title emphasize *
      "}{%" * write$
      newline$
      author format.names.first ", " * title emphasize *
    }
  if$
  "}{%" * write$
  newline$
  "father}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fathers.output.item}
{ newline$
  "\sblbibitem{%" write$
  newline$
  "}{%" write$
  newline$
  "}{%" write$
  newline$
  "father}{%" write$
  newline$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {article}
{ article.output.item
  format.author.bib output
  new.block
  title enquote.bib " " *
  journal emphasize *
  volume empty$
    { }
    { 
      " " * volume *
      number empty$
        { }
        { ", no.~" * number * }
      if$
    }
  if$
  " (" *
  month empty$
    { "" * }
    { month * " " * }
  if$
  year * "): " * pages n.dashify * output
  url empty$
    { }
    { 
      new.block
      "Cited " cited * ". Online: \protect\url{" * url * "}" *  output
    }
  if$
  fin.entry
}

FUNCTION {book}
{ book.output.item
  format.author.bib output
  new.block
  volumetitle empty$
    {
      title emphasize output 
    }
    {
      volumetitle emphasize output
      "Vol.~" volume * " of " * title emphasize * output
    }
  if$
  new.block
  format.editor.translator.bib
  volumes empty$
    { }
    {
      volumes "~vols" * output
      new.block
    }
  if$
  edition empty$
    { }
    {
      format.edition output
      new.block
    }
  if$
  format.series empty$
    { }
    {
      format.series output
      new.block
    }
  if$
  output.origpubdetails.bib
  address ": " * publisher * output
  year output
  url empty$
    { }
    { 
      new.block
      "Cited " cited * ". Online: \protect\url{" * url * "}" *  output
    }
  if$
  fin.entry
}

FUNCTION {dictionary}
{ dictionary.output.item
  format.author.bib output
  new.block
  title enquote.bib " " *
  pages multi.page.check
    { "Pages" pages n.dashify tie.or.space.connect * }
    { "Page" pages tie.or.space.connect * }
  if$
  volume empty$
    { " in " * dictionarytitle emphasize * output }
    { " in vol.~" * volume * " of " * dictionarytitle emphasize * output }
  if$
  new.block
  format.editor.translator.bib
  volumes empty$
    { }
    { volumes "~vols" * output new.block }
  if$
  output.origpubdetails.bib
  address ": " * publisher * output
  year output
  fin.entry
}

FUNCTION {introduction}
{ introduction.output.item
  format.author.bib output
  new.block
  introtype "t" change.case$ " to " *
  volumetitle empty$
    {
      title emphasize *
    }
    {
      volumetitle emphasize *
      "Vol.~" * volume * " of " * title emphasize *
    }
  if$
  ", by " * bookauthor format.names.firstfull * output
  new.block
  format.editor.translator.bib
  volumes empty$
    { }
    {
      volumes "~vols" * output
      new.block
    }
  if$
  edition empty$
    { }
    {
      format.edition output
      new.block
    }
  if$
  format.series empty$
    { }
    {
      format.series output
      new.block
    }
  if$
  output.origpubdetails.bib
  address ": " * publisher * output
  year output
  fin.entry
}

FUNCTION {lexicon}
{ lexicon.output.item
  fin.entry
}


FUNCTION {incollection}
{ incollection.output.item
  author empty$
    { }
    {
      format.author.bib output
      new.block
    }
  if$
  title enquote.bib " " *
  pages multi.page.check
    { "Pages" pages n.dashify tie.or.space.connect * }
    { "Page" pages tie.or.space.connect * }
  if$
  volumetitle empty$
    { " in " * booktitle emphasize * output }
    { 
      " in " * volumetitle emphasize * "." * output
      new.block
      volumeeditor empty$
        { }
        {
          "Edited by " volumeeditor format.names.firstfull * output
          new.block
        }
      if$
      " Vol.~" volume * " of " * booktitle emphasize * output
    }
  if$
  new.block
  editor empty$
    { }
    {
      "Edited by " editor format.names.firstfull * output
      new.block
    }
  if$
  translator empty$
    { }
    {
      "Translated by " translator format.names.firstfull * output
      new.block
    }
  if$
  edition empty$
    { }
    {
      format.edition output
      new.block
    }
  if$
  format.series empty$
    { }
    {
      format.series output
      new.block
    }
  if$
  output.origpubdetails.bib
  address ": " * publisher * output
  year output
  fin.entry
}

FUNCTION {inbook}
{ incollection
}

FUNCTION {online}
{ online.output.item
  format.author.bib output
  new.block
  title enquote.bib " No pages. Cited " * cited * output
  new.block
  "Online: \protect\url{" url * "}" * output
  fin.entry
}

FUNCTION {electronic}
{ online
}

FUNCTION {onlinemedia}
{ onlinemedia.output.item
  format.author.bib output
  new.block
  title enquote.bib " " * format.series * output
  new.block
  publisher output
  new.block
  " Cited " cited * output
  new.block
  "Online: " howpublished * " \protect\url{" * url * "}" * output
  fin.entry
}

FUNCTION {phdthesis}
{ phdthesis.output.item
  format.author.bib output
  new.block
  title enquote.bib " " *
  "Ph.D.\ diss., " * school * ", " * year * output
  fin.entry
}

FUNCTION {mastersthesis}
{ mastersthesis.output.item
  format.author.bib output
  new.block
  title enquote.bib " " *
  "Masters diss., " * school * ", " * year * output
  fin.entry
}

FUNCTION {misc}
{ misc.output.item
  bibform output
  fin.entry
}

FUNCTION {father}
{ father.output.item
  author empty$
    { }
    {
      format.author.bib output
      new.block
      booktitle emphasize output 
      new.block
      format.series empty$
        { }
        {
          format.series output
          new.block
        }
      if$
      format.editor.translator.bib
      volumes empty$
        { }
        {
          volumes "~vols" * output
          new.block
        }
      if$
      output.origpubdetails.bib
      address ": " * publisher * output
      year output
    }
  if$
  fin.entry
}

FUNCTION {fathers}
{ fathers.output.item
  title emphasize output 
  new.block
  format.series empty$
    { }
    {
      format.series output
      new.block
    }
  if$
  format.editor.translator.bib
  volumes empty$
    { }
    {
      volumes "~vols" * output
      new.block
    }
  if$
  output.origpubdetails.bib
  address ": " * publisher * output
  year output
  fin.entry
}


FUNCTION {default.type} { book }

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$
      s nameptr "{ll{ }}{  ff{ }}{  vv{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
	{ "et~al." * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
	{ key empty$
	    { "to sort, need author, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
	{ key empty$
	    { "to sort, need editor, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ type$ "book" =
  type$ "misc" =
  or
    'author.editor.sort
    { type$ "proceedings" =
	'editor.organization.sort
	{ type$ "manual" =
	    'author.organization.sort
	    'author.sort
	  if$
	}
      if$
    }
  if$
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label prev.author this.author }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
  "abcxyz" 'prev.author :=
  "" 'this.author :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
  author empty$
    { editor empty$
        { "" }
        'editor
      if$
    }
    'author
  if$
  'this.author :=
  this.author prev.author =
    { "\bysame" 'bysame := }
    { "" 'bysame :=
      this.author "" =
        { "abcxyz" }
        'this.author
      if$
      'prev.author :=
    }
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\providecommand{\bysame}{\leavevmode\raise 0.5ex\hbox to 3em{\hrulefill}}"
  write$ newline$
  "\begin{thebibliography}{}" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
