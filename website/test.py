class MyHTMLParser(HTMLParsing):
    def handle_starttag(self, tag, attrs):
        el = Element(tag, attrs)
        self._stack[-1].children.append(el)
        self._stack.append(el)
    def handle_endtag(self, tag):
        assert tag == self._stack[-1].tag
        self._stack[-1].pop()
    def handle_data(self, data):
        self._stack[-1].append(data)

def parse(html):
    n = DocumentRoot()
    p = MyHTMLParser(n)
    p.feed(html)
    p.close()
    return n

print(parse("<div></div>"))

def toc_context(el):
    tocs = []
    for node in iterate(el):
        if isinstance(node, Element) and node.tag == 'ul':
            tocs.append(node)
        elif isinstance(node, Element) and node.tag == 'h2':
            headings.append(node)
    toc = [
        h('li', [h('a', {'href': heading.id}, [heading.text]
