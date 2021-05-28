<html>
<head>
  <meta charset="UTF-8">
  <title>◊(select 'h1 doc) to select an html element</title>
  <link rel="stylesheet" type="text/css" href="styles.css"/>
</head>
<body>
,or can use a selector in pollen style: ◊select['h1 doc]
◊(->html doc)
The current page is called ◊|here|.
◊when/splice[(and (previous here) (regexp-match "article" (symbol->string (previous here))))]{The previous is <a href="◊|(previous here)|">◊|(previous here)|</a>.}
◊when/splice[(and (next here) (regexp-match "article" (symbol->string (next here))))]{The next is <a href="◊|(next here)|">◊|(next here)|</a>.}
</body>
</html>