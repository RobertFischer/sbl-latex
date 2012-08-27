%% sblessay.cls [2009/10/15]
%% Copyright 2008-2009 David Purton
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
% Thanks to Pete Myers <peterdanielmyers@googlemail.com> for tailoring
% the class more closely to SBL requirements.
%
% This work consists of the files sblref.sty, sbllanghe.sty,
%   sbllanggr.sty, sbllangen.sty, sbl.bst, and sblessay.cls

\ProvidesClass{sblessay}[2010/04/22 SBL Essay Class]

\RequirePackage{ifxetex}
\RequirePackage{sblfakesc}

\newif\if@openright
\newif\if@twoside
%\newif\if@raggedright
\newif\if@firstrefwithpage
\newif\if@usetimes
\newif\if@afourpaper
\newif\if@sbllanghe
\newif\if@sbllanggr

% Explicit Defaults
\@afourpapertrue
\@sbllanghetrue
\@sbllanggrtrue

\DeclareOption{rmheadings}
  {\def\headingfontfamily{\rmfamily}}
\DeclareOption{firstrefwithpage}
  {\@firstrefwithpagetrue}
\DeclareOption{sfheadings}
  {\def\headingfontfamily{\sffamily}}
\DeclareOption{oneside}
  {\@twosidefalse}
\DeclareOption{twoside}
  {\@twosidetrue}
\DeclareOption{openright}
  {\@openrighttrue}
\DeclareOption{openany}
  {\@openrightfalse}
\DeclareOption{times} {
  \@usetimestrue
  \usefakesc
}
\DeclareOption{notimes} {
  \@usetimesfalse
  \userealsc
}
\DeclareOption{fakesc} {
  \usefakesc
}
\DeclareOption{nofakesc} {
  \userealsc
}
\DeclareOption{nogreek}
  {\@sbllanggrfalse}
\DeclareOption{nohebrew}
  {\@sbllanghefalse}
\DeclareOption{greek}
  {\@sbllanggrtrue}
\DeclareOption{hebrew}
  {\@sbllanghetrue}
\DeclareOption{a4paper}
  {\@afourpapertrue}
\DeclareOption{letterpaper}
  {\@afourpaperfalse}
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ExecuteOptions{rmheadings,openany,times,greek,hebrew}
\ProcessOptions\relax
\LoadClass[12pt,oneside]{article}  % Relying on geometry for paper size

\RequirePackage{setspace}
\RequirePackage[overload]{textcase}
\RequirePackage{afterpage}

% Ragged right settings
%\RequirePackage{ragged2e}
%\setlength\RaggedRightRightskip{0pt plus 1fil} % With hypenation: {0pt plus 10mm}
%\setlength\RaggedRightParfillskip{0pt plus 1fil}
%\RaggedRight

% Install language support
\RequirePackage{sbllangbase}  % Gives some font control commands
\if@sbllanggr
  \RequirePackage{sbllanggr}
\fi
\if@sbllanghe
  \RequirePackage{sbllanghe}
\fi

% Margin settings
\RequirePackage{geometry}
\if@afourpaper
  \geometry{a4paper}
\else 
  \geometry{letterpaper}
\fi
\geometry{margin=1in}
\geometry{headsep=5mm}
\RequirePackage{changepage}

% sbl reference settings
\if@firstrefwithpage
  \RequirePackage[firstrefwithpage]{sblref}
\else
  \RequirePackage{sblref}
\fi

% more sane ellipses
\IfFileExists{ellipsis.sty}{
  \RequirePackage{ellipsis}
  \renewcommand\ellipsispunctuation{,.:;!?\bgroup\egroup}
}{}

% footnote settings
\RequirePackage{fnpos}
\makeFNbottom
\makeFNbelow
\setlength\footskip{1cm}
\renewcommand{\footnotemargin}{0.5in}
\renewcommand{\hangfootparindent}{0.5in}
%\renewcommand{\footnotelayout}{\RaggedRight}
\setlength{\footnotesep}{16pt}
\def\footnoterule{\kern-3\p@
  \vrule \@width \z@ \@height 1mm \@depth \z@
  \hrule \@width 2in \kern 2.6\p@} % the \hrule is .4pt high

% general formatting settings
\doublespacing
\parindent 0.5in
\pagestyle{myheadings}
\clubpenalty1000
\widowpenalty1000
\if@usetimes
  \ifxetex
    \setromanfont[Mapping=tex-text]{Times New Roman}
    \setsansfont[Mapping=tex-text]{Arial}
  \else
    \RequirePackage{times}
  \fi
\fi

% Count number of appendices
% Unless the numapp script is run twice it doesn't work
% You MUST compile the document twice every time
\makeatletter
\newcounter{numapp}
\newcommand{\numberofapp}{%
    \immediate\write\@auxout%
      {\string\setcounter{numapp}{\the\c@section}}%
}
\AtBeginDocument{\AtEndDocument{\numberofapp}}
\makeatletter

% block quotations
\renewenvironment{quotation}
                 {\list{}{\itemsep       \z@%
                          \itemindent    \z@%
                          \listparindent 0.5in%
                          \leftmargin    0.5in%
                          \rightmargin   0.5in%
                          \partopsep     \z@%
                          \topsep        2.5ex \@plus 0.5ex \@minus 0.5ex%
                          \parsep        \z@ \@plus\p@}%
                  \item\relax\singlespacing}
                 {\endlist%
                  \global\parindent 0.5in}

\renewenvironment{quote}
                 {\list{}{\itemsep       \z@%
                          \itemindent    \z@%
                          \listparindent \z@%
                          \leftmargin    0.5in%
                          \rightmargin   0.5in%
                          \partopsep     \z@%
                          \topsep        2.5ex \@plus 0.5ex \@minus 0.5ex%
                          \parsep        1.5ex \@plus 0.25ex}%
                  \item\relax\singlespacing}
                 {\endlist%
                  \global\parindent 0.5in}

\newif\ifverseparsep
\verseparsepfalse
\def\newverse{\vskip\baselineskip}
\renewenvironment{verse}
                 {\def\\{\newline\hspace*{-0.5in}}%
                  \list{}{\itemsep       \z@%
                          \itemindent    -0.75in%
                          \listparindent \itemindent%
                          \leftmargin    1.25in%
                          \rightmargin   0.5in%
                          \partopsep     \z@%
                          \topsep        2.5ex \@plus 0.5ex \@minus 0.5ex%
                          \ifverseparsep%
                            \parsep        1.5ex \@plus 0.25ex%
                          \else%
                            \parsep=0ex%
                          \fi}%
                  \item\relax\singlespacing}
                 {\endlist%
                  \global\parindent 0.5in}

% slight modification of cleardoublepage so that blank page does not have a
% page number
\renewcommand{\cleardoublepage}{%
  % original definition, see latex.ltx
  \clearpage
  \if@twoside
    \ifodd\c@page
    \else
      \thispagestyle{empty}% added
      \hbox{}\newpage
      \if@twocolumn
        \hbox{}\newpage
      \fi
    \fi
  \fi
}

% title page
\renewcommand\maketitle{
  \begin{titlepage}%
  \setlength\textheight{7.693in}
  \changepage{}{-2in}{}{1in}{}{}{}{}{}
  \setlength\voffset{1in}
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \centering
    \MakeUppercase \@institution \par
    \vfill
    \MakeUppercase \@title \par
    \vfill
    \singlespacing
    SUBMITTED TO \MakeUppercase \@professor \par
    IN PARTIAL FULFILLMENT OF \par \MakeUppercase \@coursenumber\ \MakeUppercase \@coursetitle \par
    \doublespacing
    \vfill
    \MakeUppercase \@author \par
    \vfill
    \MakeUppercase \@date \par
  \@thanks
  \setlength\textheight{9.693in}
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\author#1{\gdef\@author{#1}}
\def\@author{[Your name]}
\def\title#1{\gdef\@title{#1}}
\def\@title{Title of Paper}
\def\institution#1{\gdef\@institution{#1}}
\def\@institution{[Name of Institution]}
\def\professor#1{\gdef\@professor{#1}}
\def\@professor{[Name of Professor]}
\def\coursenumber#1{\gdef\@coursenumber{#1}}
\def\@coursenumber{[Course Number}
\def\coursetitle#1{\gdef\@coursetitle{#1}}
\def\@coursetitle{and Title]}

\newcommand{\firstpage}{%
  \newfrontpage
  \pagenumbering{arabic}
}

\newcommand{\newfrontpage}{%
  {\if@openright
     \cleardoublepage
   \else
     \clearpage
   \fi
   \global\parindent 0in%
   \global\everypar{%
   \global\parindent 0.5in%
   \global\everypar{}%
   }}%
  \global\topskip=1in%
  \setcounter{oldpage}{\value{page}}%
  \thispagestyle{plain}%
  \afterpage{\global\topskip=0in}%
}

\renewenvironment{titlepage}
    {%
      \@restonecolfalse\newpage
      \thispagestyle{empty}%
    }{%
      \firstpage
      \addtocounter{oldpage}{-1}%
    }%

% Heading names
\def\sbl@abstractname{ABSTRACT}
\def\sbl@bibliographyname{BIBLIOGRAPHY}
\def\sbl@abbreviationname{LIST OF ABBREVIATIONS}
\def\sbl@contentsname{CONTENTS}

% try to start things on the right page
\newcounter{oldpage}

% abstract
\renewenvironment{abstract}{%
      \@restonecolfalse\newpage
      \thispagestyle{empty}%
      {\@beginparpenalty\@lowpenalty
      \begin{center}%
        \headingfontfamily\sbl@abstractname
        \@endparpenalty\@M
        \vspace*{-0.05in}%
      \end{center}}\parindent 0.5in}%
     {\par\firstpage
      \addtocounter{oldpage}{-1}%
     }

% table of contents
\renewcommand\tableofcontents{%
      \@restonecolfalse\newpage
      \pagenumbering{roman}%
      {\@beginparpenalty\@lowpenalty
      \begin{center}%
        \headingfontfamily\sbl@contentsname
        \@endparpenalty\@M
        \vspace*{-0.05in}%
      \end{center}}%
      {%
      \@starttoc{toc}}%
    \firstpage
    }

% abbreviations
\newenvironment{abbreviations}{%
      \addcontentsline{toc}{section}{\sbl@abbreviationname}%
      \@restonecolfalse\newpage
      \pagenumbering{roman}%
      \setcounter{page}{\value{oldpage}}%
      {\@beginparpenalty\@lowpenalty
      \begin{center}%
        \headingfontfamily\sbl@abbreviationname
        \@endparpenalty\@M
        \vspace*{-0.05in}%
      \end{center}}%
      \singlespacing
      \list{}{\itemsep\z@
              \itemindent\z@
              \listparindent\z@
              \leftmargin 1in%
              \rightmargin\z@
              \labelwidth 1in%
              \labelsep\z@%
              \def\makelabel##1{\rlap{##1}\hss}%
      }}%
    {\endlist\firstpage}


% Use this if using openright without an abstract. It inserts a blank page so
% the main essay begins on the right hand side since it will always be page 1.
% It doesn't break if you are using openany.
\newcommand{\noabstract}{%
  \if@openright
  \else
    \quad
    \thispagestyle{empty}
    \newpage
    \firstpage
  \fi
}

\def\@afterheading{%
  \@nobreaktrue
  \everypar{%
    \global\parindent 0.5in % add to ensure parindent is restored correctly
    \if@nobreak
      \@nobreakfalse
      \clubpenalty \@M
      \if@afterindent\else
        {\setbox\z@\lastbox}%
      \fi
    \else
      \clubpenalty \@clubpenalty
      \everypar{}%
    \fi}}

% bibliography
\def\bibliography#1{%
  \if@filesw
    \immediate\write\@auxout{\string\bibdata{#1}}%
  \fi
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \thispagestyle{plain}
  \singlespacing
  \@input@{\jobname.bbl}}
  
\renewenvironment{thebibliography}[1]{%
     \addcontentsline{toc}{section}{\sbl@bibliographyname}%
     \begin{center}
        {\vrule width \z@ height .825in depth \z@ 
           \headingfontfamily\sbl@bibliographyname}
        \vspace*{0.5\baselineskip}
      \end{center}%
      \list{}%
           {\itemindent -0.5in
            \leftmargin 0.5in
           }%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist
      \if@restonecol\twocolumn\fi}

% section headings
\renewcommand\part{\@startsection {part}{0}{\z@}%
  {-24pt \@plus -1ex \@minus -.2ex}%
  {3ex \@plus .2ex}%
  {\centering\singlespacing\normalfont\headingfontfamily\MakeUppercase}}
\renewcommand\section{\@startsection {section}{1}{\z@}%
  {-24pt \@plus -1ex \@minus -.2ex}%
  {0.5ex \@plus .2ex}%
  {\centering\singlespacing\normalfont\headingfontfamily\normalsize\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-24pt \@plus -1ex \@minus -.2ex}%
  {0.5ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-24pt \@plus -1ex \@minus -.2ex}%
  {0.5ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize\bfseries\itshape}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
  {-24pt \@plus -1ex \@minus -.2ex}%
  {0.5ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
  {2ex \@plus 1ex \@minus .2ex}%
  {-1em}%
  {\normalfont\headingfontfamily\normalsize\em}}

% appendices
\newcommand\apsection{%
  \if@openright%
    \cleardoublepage%
  \else
    \clearpage%
  \fi%
  \thispagestyle{plain}%
  \noindent%
  \vrule width \z@ height 1.15in depth \z@
  \hfill%
  \ifnum\value{subsection}<1%
    APPENDIX%
  \else%
  \fi%
  \ifnum\value{numapp}>1%
    \addtocounter{section}{1}%
    \ \@arabic\c@section%
    \addtocounter{section}{-1}%
  \fi%
  \hfill\vrule width \z@ depth \z@%
  \def\@seccntformat##1{}% stop showing counter
  \@startsection {section}{1}{\z@}%
  {-.0001pt \@plus -1ex \@minus -.2ex}% must be non-zero to stop next parindent
  {3ex \@plus .2ex}%
  {\centering\singlespacing\normalfont\headingfontfamily\MakeUppercase}%
}
\newcommand\apsubsection{%
  \def\@seccntformat##1{\csname the##1\endcsname\quad}% resume showing counter
  \@startsection{subsection}{2}{\z@}%
  {-24pt \@plus -1ex \@minus -.2ex}%
  {0.5ex \@plus .2ex}%
  {\centering\singlespacing\normalfont\headingfontfamily\normalsize\bfseries}}

% use to start the appendices
% sets the section commands to the above appendix section commands
\renewcommand\appendix{%
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \let\section\apsection%
  \let\subsection\apsubsection%
}
