%!TEX TS-program = xelatex
%!TEX encoding = UTF-8 Unicode
% Awesome CV LaTeX Template for CV/Resume
%
% This template has been downloaded from:
% https://github.com/posquit0/Awesome-CV
%
% Author:
% Claud D. Park <posquit0.bj@gmail.com>
% http://www.posquit0.com
%
% Template license:
% CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)
%

%-------------------------------------------------------------------------------
% CONFIGURATIONS
%-------------------------------------------------------------------------------
% A4 paper size by default, use 'letterpaper' for US letter
\documentclass[11pt, letterpaper]{awesome-cv}
% Configure page margins with geometry
\geometry{left=1.4cm, top=.8cm, right=1.4cm, bottom=1.8cm, footskip=.5cm}
% Specify the location of the included fonts
\fontdir[fonts/]
% Color for highlights
% Awesome Colors: awesome-emerald, awesome-skyblue, awesome-red, awesome-pink, awesome-orange
%                 awesome-nephritis, awesome-concrete, awesome-darknight
\colorlet{awesome}{awesome-red}
% Uncomment if you would like to specify your own color
% \definecolor{awesome}{HTML}{CA63A8}

% Colors for text
% Uncomment if you would like to specify your own color
% \definecolor{darktext}{HTML}{414141}
% \definecolor{text}{HTML}{333333}
% \definecolor{graytext}{HTML}{5D5D5D}
% \definecolor{lighttext}{HTML}{999999}

% Set false if you dont want to highlight section with awesome color
\setbool{acvSectionColorHighlight}{true}

% If you would like to change the social information separator from a pipe (|) to something else
\renewcommand{\acvHeaderSocialSep}{\quad\textbar\quad}

%-------------------------------------------------------------------------------
%	personal information
%	comment any of the lines below if they are not required
%-------------------------------------------------------------------------------
% available options: circle|rectangle,edge/noedge,left/right
% \photo[rectangle,edge,right]{./examples/profile}
\name{jacob}{chvatal}
\position{software architect{\enskip\cdotp\enskip}security expert}
\address{42-8, bangbae-ro 15-gil, seocho-gu, seoul, 00681, rep. of korea}

\mobile{(+82) 10-9030-1843}
\email{posquit0.bj@gmail.com}
\homepage{www.posquit0.com}
\github{posquit0}
\linkedin{posquit0}
% \gitlab{gitlab-id}
% \stackoverflow{so-id}{so-name}
% \twitter{@twit}
% \skype{skype-id}
% \reddit{reddit-id}
% \medium{madium-id}
% \googlescholar{googlescholar-id}{name-to-display}
%% \firstname and \lastname will be used
% \googlescholar{googlescholar-id}{}
% \extrainfo{extra informations}

%-------------------------------------------------------------------------------

\begin{document}
\title{◊select['h2 doc] - Resume}

◊(require racket/list)
◊(apply string-append (filter string? (flatten doc)))
\end{document}
