#lang pollen
 
<!DOCTYPE html>
<html>
<head>
◊(define inside 2)
◊(define edge (* inside 4))
◊(define color "blue")
<style type="text/css">
pre {
    margin: ◊|edge|em;
    border: ◊|inside|em solid ◊|color|;
    padding: ◊|inside|em;
}
</style>
</head>
<body>
<pre>
The margin is ◊|edge|em.
The border is ◊|color|.
The padding is ◊|inside|em.
The border is too.
</pre>
</body>
</html>