%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rcfsblessay}[2010/05/05
Robert Fischer's class for Society of Biblical Literature essays]

\DeclareOption*{ \PassOptionsToClass{\CurrentOption}{ddsessay} }
\ProcessOptions\relax
\LoadClass{ddsessay}

\let\heb\he

\RequirePackage{xspace}
\RequirePackage{hyphenat}
\RequirePackage{scalefnt}
\RequirePackage{verbatim}


\newcommand\makestart[0] {
  \maketitle
}

\RequirePackage{bibleref}
\def\br@Jeremiah{\BRbookof Jeremiah}%  Typo in original file

\RequirePackage{bibleref-parse}

% ARGS: Quote, book, chapter:verse, version
\newcommand{\biblequote}[4] {%
   ``#1''~(\ibibleverse{#2}(#3)\expandafter\xspace\expandafter\bibleversioncite{#4})\xspace% 
}

\newboolean{rcfsblpaper-multibible}
\setboolean{rcfsblpaper-multibible}{false}

\newboolean{rcfsblpaper-sawabible}% 
\setboolean{rcfsblpaper-sawabible}{false}

\newcommand{\ismultibible} {% 
  \setboolean{rcfsblpaper-multibible}{true}%
}

\newcommand{\bibleversioncite}[1] {%
  \provideboolean{rcfsblpaper-bible-#1}%
  \ifthenelse{\boolean{rcfsblpaper-multibible}}{%
    \bibleabbrv{#1}%
  }{%
    \ifthenelse{\boolean{rcfsblpaper-bible-#1}} {}{%
      \bibleabbrv{#1}%
      \setboolean{rcfsblpaper-bible-#1}{true}%
      \ifthenelse{\boolean{rcfsblpaper-sawabible}}{%
        \ismultibible%
      }{%
        \setboolean{rcfsblpaper-sawabible}{true}%
      }%
    }%
  }%
}

\newcommand{\bibleabbrv}[1] {%
  \textsc{\MakeLowercase{#1}}%
}
\newcommand{\bibleabbr}[1] {%
  \bibleabbrv{#1}%
}

\renewcommand\makebib {
  \bibliography{religious}{}
}
