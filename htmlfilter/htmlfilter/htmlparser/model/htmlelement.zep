namespace HtmlFilter\HtmlParser\Model;

class HtmlElement extends HtmlModelAbstract
{
    /**
     * Holds the html elements that are considered empty
     * @var array emptyElements
     */
    protected emptyElements = [
        "area", "br", "col",
        "embed", "hr", "img",
        "input", "isindex", "param"
    ] {
        get, set
    };

    /**
     * List of valid html tags
     * @var array validHtmlTags
     * @todo list is incomplete, quite a few tags missing
     */
    protected validHtmlElements = [
        "span", "div", "iframe", "p",
        "strong", "applet", "video",
        "noscript", "form", "button", "a",
        "del", "dd", "fieldset",
        "iframe", "ins", "li", "object",
        "td", "th", "abbr", "acronym", "address", "b", "bdo",
        "big", "caption", "cite", "code", "dfn", "dt",
        "em", "font", "h1", "h2", "h3", "h4", "h5",
        "h6", "i", "kbd", "label", "legend",
        "pre", "q", "rb", "rt", "s", "samp", "small",
        "span", "strike","sub", "sup", "tt", "script",
        "u", "var", "blockquote", "map", "input"
    ] {
        get, set
    };

    /**
     * Verifies is a tag is in the whitelist of available tags
     * @param string tag
     *
     * @return boolean
     */
    public function isTagValid(const string! tag) -> boolean
    {
        return in_array(strtolower(tag), this->getValidHtmlElements());
    }

    /**
     * asserts if the element as close tag
     *
     * @return boolean
     */
    public function isEmptyElement(string! tag) -> boolean
    {
        return in_array(strtolower(tag), this->getEmptyElements());
    }

    /**
     * Adds a new html tag to the valid element tags
     *
     * @param string tagName
     */
    public function addHtmlElementAsValid(string! tagName)
    {
        if !this->isTagValid(tagName) {
            let this->validHtmlElements[] = strtolower(tagName);
        }
    }
}