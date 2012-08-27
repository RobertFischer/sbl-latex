%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rcfsblpaper}[2010/04/22
DEPRECATED Robert Fischer's class for Society of Biblical Literature papers]

\DeclareOption*{ \PassOptionsToClass{\CurrentOption}{rcfsblessay} }
\ProcessOptions\relax
\LoadClass{rcfsblessay}
