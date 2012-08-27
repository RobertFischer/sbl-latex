%% ridleyessay.cls [2009/10/14]
%% Copyright 2009 David Purton
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

\ProvidesClass{ridleyessay}[2009/10/14
                         Ridley Melbourne Essay Class]

\newif\ifridley@usetimes

\DeclareOption{times}{%
  \ridley@usetimestrue}
\DeclareOption{notimes}{%
  \ridley@usetimesfalse}
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{sblessay}%
}
\ProcessOptions\relax

% Load sblessay.cls
\ifridley@usetimes
  \LoadClass[times]{sblessay}
\else
  \LoadClass[notimes]{sblessay}
\fi

% sblref options (singlequotes,punctuationoutsidequotes)
\def\sblstartquote{\sblsinglestartquote}
\def\sblendquote{\sblsingleendquote}
\def\endtitle{\sblendquote,}
\def\endbibtitle{\sblendquote.}
\def\volendtitle{\sblendquote,}
\punctoutsidetrue

% text layout
\justifying
\renewcommand{\footnotelayout}{}
\if@twoside
  \geometry{inner=1.5in}
\else
  \geometry{left=1.5in}
\fi
\makeFNmid

% Ridley Melbourne Title Page
\newdimen\titleboxwidth
\renewcommand{\maketitle}{
  \begin{titlepage}
    \addtolength{\topmargin}{1in}
    \addtolength{\textwidth}{-0.5in}
    \addtolength{\linewidth}{-0.5in}
    \singlespacing
    \tabcolsep=0em
    \parindent=0em
    \setlength{\fboxsep}{5mm}
    \setlength{\titleboxwidth}{\linewidth}
    \addtolength{\titleboxwidth}{-2\fboxsep}
    \addtolength{\titleboxwidth}{-2\arrayrulewidth}
    \fbox{
      \parbox{\titleboxwidth}{
        \begin{tabular}{p{0.3\titleboxwidth}p{0.7\titleboxwidth}}
          Student number: & \@studentnumber \vspace{2mm} \\
          Course: & \@course \vspace{2mm} \\
          Unit: & \@unit \vspace{2mm} \\
          Title: & \@title \vspace{2mm} \\
          Word count: & \@wordcount \vspace{2mm} \\
          Date due: & \@duedate \vspace{2mm} \\
          Date submitted: & \@submitteddate \vspace{2mm} \\
          Disclaimer: & \vspace{2mm} \\
        \end{tabular}

        \textit{The following assignment, of which I have kept a copy, is
          entirely the work of the undersigned and all sources of ideas and
            expressions are duly acknowledged in footnotes or endnotes.}
        \vspace{10mm}
        
        Signed:\hfill \vrule height0mm depth\arrayrulewidth width2.2in\hfill
        Date:\hfill \vrule height0mm depth\arrayrulewidth width1.2in
      }
    }
  \end{titlepage}
}
\def\duedate#1{\gdef\@duedate{#1}}
\def\@duedate{\@latex@warning@no@line{No \noexpand\duedate given}}
\def\course#1{\gdef\@course{#1}}
\def\@course{\@latex@warning@no@line{No \noexpand\course given}}
\def\submitteddate#1{\gdef\@submitteddate{#1}}
\def\@submitteddate{\two@digits{\the\day}/\two@digits{\the\month}/\the\year}
\def\studentnumber#1{\gdef\@studentnumber{#1}}
\def\@studentnumber{\@latex@warning@no@line{No \noexpand\studentnumber given}}
\def\unit#1{\gdef\@unit{#1}}
\def\@unit{\@latex@warning@no@line{No \noexpand\unit given}}
\def\wordcount#1{\gdef\@wordcount{#1}}
% use wcridley.pl (if it exists) to count words on the fly
% enable \write18 with the --shell-escape option to latex
\def\@wordcount{\immediate\write18{wcridley.pl "\jobname.tex" > "\jobname.wds"}%
  \IfFileExists{\jobname.wds}{\input{\jobname.wds}}{%
  \@latex@warning@no@line{No \noexpand\wordcount given}}}

% Heading names
\def\sbl@abstractname{{\bfseries Abstract}}
\def\sbl@bibliographyname{{\bfseries Bibliography}}
\def\sbl@abbreviationname{{\bfseries List of Abbreviations}}
\def\sbl@contentsname{{\bfseries Contents}}

% Section headings
\renewcommand\section{\@startsection {section}{1}{\z@}%
  {-2.75ex \@plus -1ex \@minus -.2ex}%
  {1.5ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\large\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-2.5ex\@plus -1ex \@minus -.2ex}%
  {1.25ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-2.25ex\@plus -1ex \@minus -.2ex}%
  {1ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize\em}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
  {2.25ex \@plus 1ex \@minus .2ex}%
  {-1em}%
  {\normalfont\headingfontfamily\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
  {2ex \@plus 1ex \@minus .2ex}%
  {-1em}%
  {\normalfont\headingfontfamily\normalsize\em}}

% Contents style
\renewcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{4.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \endgroup
  \fi}
\renewcommand*\l@subsection{\@dottedtocline{2}{1.5em}{4.5em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{6em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4.5em}{7.5em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{6em}{9em}}

% Appendices
\renewcommand\apsection{\@startsection {section}{1}{\z@}%
  {-2.5ex\@plus -1ex \@minus -.2ex}%
  {1.5ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize\bfseries}}
\renewcommand\apsubsection{\@startsection{subsection}{2}{\z@}%
  {-2.25ex\@plus -1ex \@minus -.2ex}%
  {1.25ex \@plus .2ex}%
  {\flushleft\singlespacing\normalfont\headingfontfamily\normalsize\em}}

\renewcommand\appendix{%
  \if@openright%
    \cleardoublepage%
  \else
    \clearpage%
  \fi%
  \thispagestyle{plain}%
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \gdef\thesection{\ifnum\value{subsection}<1
                     Appendix
                   \else%
                   \fi%
                   \@Alph\c@section}%
  \let\section\apsection%
  \let\subsection\apsubsection%
  \noindent{\vrule width \z@ height 1.165in depth \z@%
    \normalfont\headingfontfamily\large\bfseries Appendices}%
}
