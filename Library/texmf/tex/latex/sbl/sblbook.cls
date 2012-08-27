%% sblbook.cls
%% Copyright 2011 David Purton
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
%

\ProvidesClass{sblbook}[2011/06/03 SBL Book Class]

\LoadClass[10pt]{book}

\RequirePackage{geometry}
\RequirePackage{afterpage}


% paper size options
% default is the trim size of 6 x 9 in
\DeclareOption{6x9paper}{%
  \geometry{%
    papersize={6in,9in},%
    layoutsize={6in,9in}%
  }%
}
\DeclareOption{a4paper}{%
  \geometry{%
    paper=a4paper,%
    layoutsize={6in,9in},%
    layoutoffset={28.2mm,34.2mm}%
  }%
}
\DeclareOption{a5paper}{%
  \geometry{%
    paper=a5paper,%
    layout=a5paper%
  }%
}
\DeclareOption{letterpaper}{%
  \geometry{%
    paper=letterpaper,
    layoutsize={6in,9in},%
    layoutoffset={1.25in,1in}%
  }%
}
\ExecuteOptions{6x9paper}
\ProcessOptions\relax


% set up plain page style
\geometry{%
  driver=xetex,%
  includeall,%
  nomarginpar,%
  margin=.75in,%
  top=3in,%
  nohead,%
  footskip=.3in%
}
\savegeometry{plain}
% set up default page style
\geometry{%
  top=.75in,%
  nofoot,%
  head=.1in,%
  headsep=.2in%
}
\newcommand{\plainpage}{%
  \cleardoublepage
  \thispagestyle{plain}%
  \loadgeometry{plain}%
  \afterpage{\aftergroup\restoregeometry}%
}

\RequirePackage{hyperref}
\hypersetup{%
  colorlinks = true, 
  linkcolor = red,
  citecolor = blue, 
  filecolor = red, 
  pagecolor = red,
  urlcolor = blue
}

\RequirePackage{fontspec}
\RequirePackage{xltxtra}
\RequirePackage{polyglossia}
\RequirePackage{bidi}
\RequirePackage{sblref}

\setromanfont[%
  Mapping=tex-text,%
  Script=Latin,%
  ]{Palatino Linotype}
\newfontfamily\hebrewfont[%
  Script=Hebrew,%
  Contextuals=Alternate,%
  Ligatures=Required%
  ]{SBL Hebrew}
\newfontfamily\greekfont[%
  Script=Greek%
  ]{SBL Greek}

\setotherlanguage[variant=ancient]{greek}
\setotherlanguage{hebrew}

\newcommand{\he}[1]{\texthebrew{#1}}
\newcommand{\gr}[1]{\textgreek[variant=ancient]{#1}}

\parindent .25in   % paragraph indent
\clubpenalty 1000  % supress orphans
\widowpenalty 1000 % supress widows
%\hyphenpenalty 500 % less hyphens
%\tolerance 500     % higher tolerance to cope with less hyphens

% set footnote and superscript to 9/11
\renewcommand\footnotesize{%
   \@setfontsize\footnotesize\@ixpt{11}%
   \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\renewcommand\scriptsize{\@setfontsize\scriptsize\@ixpt\@xipt}

\newenvironment{imprint}{%
\thispagestyle{empty}%
\parindent 0em%
\footnotesize
\parskip 11pt%
}{}

% abbreviations
\newenvironment{abbreviations}{%
      \list{}{\itemsep\z@
              \itemindent\z@
              \listparindent\z@
              \leftmargin 1in%
              \rightmargin\z@
              \labelwidth 1in%
              \labelsep\z@%
              \def\makelabel##1{\rlap{##1}\hss}%
      }}%
    {\endlist}


\renewenvironment{quotation}
                 {\small
                  \list{}{\listparindent .25in%
                          \itemindent    \z@
                          \leftmargin    .25in%
                          \rightmargin   \leftmargin
                          \parsep        \z@ \@plus\p@}%
                  \item\relax}
                 {\endlist}
\renewenvironment{quote}
                 {\small
                  \list{}{\listparindent .25in%
                          \itemindent    \z@
                          \leftmargin    .25in%
                          \rightmargin   \leftmargin
                          \parsep        \z@ \@plus\p@}%
                  \item\relax}
                 {\endlist}


\pagestyle{headings}
\renewcommand\@evenhead{\thepage\hfil\leftmark}%
\renewcommand\@oddhead{{\rightmark}\hfil\thepage}%
\renewcommand{\chaptermark}[1]{%
 \markboth {%
   \scshape\MakeLowercase{#1}}{}}%
\renewcommand{\sectionmark}[1]{%
 \markright {%
   \ifnum \c@secnumdepth >\z@
     \thesection. \ %
   \fi
   \scshape\MakeLowercase{#1}}}


\renewcommand\tableofcontents{%
    \chapter*{\contentsname}
    \@mkboth{%
       \scshape\MakeLowercase\contentsname}{%
       \scshape\MakeLowercase\contentsname}%
    \@starttoc{toc}%
    }

\renewenvironment{thebibliography}[1]
     {\chapter*{\refname}%
      \addcontentsline{toc}{chapter}{\refname}%
      \@mkboth{%
          \scshape\MakeLowercase\therefmark}{%
          \scshape\MakeLowercase\therefmark}%
      \footnotesize
      \list{}%
           {\itemindent -\parindent
            \leftmargin \parindent
           }%
      \sloppy
      \clubpenalty10000%
      \@clubpenalty \clubpenalty
      \widowpenalty10000%
      \sfcode`\.\@m%
      }
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}

\setcounter{secnumdepth}{0}
\def\@makechapterhead#1{%
  \plainpage
  {\parindent \z@ \raggedright \normalfont \Large
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \strut\rlap{\thechapter}\par%
      \fi
    \fi
    \addfontfeature{%
      Kerning=Uppercase,%
      WordSpace=2%
    }%
    \MakeUppercase{#1}\par\nobreak
    \vskip .5in%
  }%
}
\def\@makeschapterhead#1{%
  \plainpage
  {\parindent \z@ \raggedright \normalfont \Large
    \addfontfeature{%
      Kerning=Uppercase,%
      WordSpace=2%
    }%
    \MakeUppercase{#1}\par\nobreak
    \vskip .5in%
  }%
}
\renewcommand\section{\@startsection{section}{1}{\z@}%
                                    {-15pt \@plus -4pt \@minus -2pt}%
                                    {9pt \@plus 3pt}%
                                    {\centering\normalfont\normalsize\scshape}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                       {-9pt\@plus -3pt \@minus -1pt}%
                                       {3pt \@plus 1pt}%
                                       {\normalfont\normalsize\scshape
                                        \MakeLowercase}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                          {9pt\@plus 3pt \@minus 1pt}%
                                          {-1em}%
                                          {\normalfont\normalsize\scshape
                                           \MakeLowercase}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\parindent}%
                                      {\z@}%
                                      {-1em}%
                                      {\normalfont\normalsize\sl}}


\def\@dottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \vskip 6pt \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     {#4}\nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
     \par}%
  \fi}
\def\@tocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     {#4}\nobreak
     \hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
     \par}%
  \fi}
\renewcommand*\l@subsection{\@tocline{2}{3.8em}{3.2em}}

\newskip\sblblockskip
\sblblockskip 11pt minus 5pt

\def\endtabular{\crcr\egroup\egroup $\egroup\vskip\sblblockskip}
\def\tabular{\vskip\sblblockskip\let\@halignto\@empty\@tabular}
\@namedef{tabular*}#1{%
 \vskip\sblblockskip
 \setlength\dimen@{#1}%
   \edef\@halignto{to\the\dimen@}\@tabular}

