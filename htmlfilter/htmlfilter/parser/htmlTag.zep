namespace Htmlfilter\Parser;

class HtmlTag extends AbstractText
{
    /**
     * verifies that the element is an empty element
     * @var boolean isEmptyElement
     */
    protected isEmptyElement = false {
        set
    };

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
     * list of the possible children of the textual representation
     * @var array children
     */
    protected children = [] {
        get, set
    };

    /**
     * The html tag name pertaining this object
     * @var string tag
     */
    protected tag = "" {
        get
    };

    /**
     * Properties pertaining this specific element
     * @var array properties
     */
    protected properties = [] {
        get, set
    };

    /**
     * Creates a new html tag object
     * @param string tag
     */
    public function __construct(string! tag)
    {
        let this->tag = tag;
    }

    /**
     * asserts if the element as close tag
     * @return boolean
     */
    public function isEmptyElement() -> boolean
    {
        return in_array(strtolower(this->tag), this->getEmptyElements());
    }

    /**
     * asserts the element has children within
     * @return boolean
     */
    public function hasChildren() -> boolean
    {
        return !empty(this->children);
    }

    /**
     * adds a child to the children list
     * @param AbstractText child
     */
    public function addChild(<AbstractText> child)
    {
        let this->children[] = child;
    }

    /**
     * The passed tag should be tag name only
     * @var string tag
     */
    public function setTag(string! tag)
    {
        let this->tag = tag;
    }

    /**
     * {@inheritdoc}
     */
    public function getText() -> string
    {
        string text = "<";
        let text .= this->tag;
        var tag;
        var property;

        if !empty(this->getProperties()) {
            for property in this->getProperties() {
                let text .= " " . property;
            }
        }

        if this->isEmptyElement() {
            let text .= " />";
            return text;
        } else {
            let text .= ">";
        }

        if this->hasChildren() {
            for tag in this->children {
                let text = text . tag->getText();
            }
        }

        let text .= "</". this->tag .">";

        return text;
    }
}