namespace Htmlfilter\Parser;

class HtmlTag
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
     * quick check if the tag as any children
     * @var boolean hasChildren
     */
    protected hasChildren = false;

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
     * Text inside the element
     * @var string innerText
     */
    protected innerText = "" {
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
        return this->isEmptyElement;
    }

    /**
     * asserts the element has children within
     * @return boolean
     */
    public function hasChildren() -> boolean
    {
        return this->hasChildren;
    }

    /**
     * adds a child to the children list
     * @param HtmlTag child
     */
    public function addChild(<HtmlTag> child)
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
}