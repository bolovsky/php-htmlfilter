namespace HtmlFilter\HtmlParser;

/**
 * Class HtmlTag
 */
class HtmlTag extends AbstractText
{
    /**
     * @var <\HtmlFilter\HtmlParser\Model\HtmlElement>
     */
    protected htmlElement {
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
    protected attributes = [] {
        get, set
    };

    /**
     * Creates a new html tag object
     * @param string tag
     * @param HtmlFilter\HtmlParser\Model\HtmlElement htmlElement
     */
    public function __construct(string! tag, htmlElement=null)
    {
        let this->tag = tag;
        let this->htmlElement = htmlElement;
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
        var attribute;

        if !empty(this->getAttributes()) {
            for attribute in this->getAttributes() {
                let text .= " " . attribute;
            }
        }

        if this->getHtmlElement()->isEmptyElement(this->tag) {
            let text .= " />";
            return text;
        } else {
            let text .= ">";
        }

        if this->hasChildren() {
            for tag in this->getChildren() {
                let text .= tag->getText();
            }
        }

        let text .= "</". this->tag .">";

        return text;
    }
}