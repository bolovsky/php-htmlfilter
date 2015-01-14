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
        "span": ["permission": 1], 
        "div": ["permission": 1], 
        "iframe": ["permission": 1], 
        "p": ["permission": 1],
        "strong": ["permission": 1],
        "applet": ["permission": 1],
        "video": ["permission": 1],
        "noscript": ["permission": 1],
        "form": ["permission": 1],
        "button": ["permission": 1],
        "a": ["permission": 1],
        "del": ["permission": 1],
        "dd": ["permission": 1],
        "fieldset": ["permission": 1],
        "iframe": ["permission": 1],
        "ins": ["permission": 1],
        "li": ["permission": 1],
        "object": ["permission": 1],
        "td": ["permission": 1],
        "th": ["permission": 1],
        "abbr": ["permission": 1],
        "acronym": ["permission": 1],
        "address": ["permission": 1],
        "b": ["permission": 1], 
        "bdo": ["permission": 1],
        "big": ["permission": 1], 
        "caption": ["permission": 1],
        "cite": ["permission": 1],
        "code": ["permission": 1],
        "dfn": ["permission": 1],
        "dt": ["permission": 1],
        "em": ["permission": 1],
        "font": ["permission": 1],
        "h1": ["permission": 1],
        "h2": ["permission": 1],
        "h3": ["permission": 1],
        "h4": ["permission": 1],
        "h5": ["permission": 1],
        "h6": ["permission": 1],
        "i": ["permission": 1],
        "kbd": ["permission": 1],
        "label": ["permission": 1],
        "legend": ["permission": 1],
        "pre": ["permission": 1],
        "q": ["permission": 1],
        "rb": ["permission": 1],
        "rt": ["permission": 1],
        "s": ["permission": 1],
        "samp": ["permission": 1],
        "small": ["permission": 1],
        "span": ["permission": 1],
        "strike": ["permission": 1],
        "sub": ["permission": 1],
        "sup": ["permission": 1],
        "tt": ["permission": 1],
        "script": ["permission": 0],
        "u": ["permission": 1],
        "var": ["permission": 1],
        "blockquote": ["permission": 1],
        "map": ["permission": 1],
        "area": ["empty": 1, "permission": 1],
        "br": ["empty": 1, "permission": 1],
        "col": ["empty": 1, "permission": 1],
        "embed": ["empty": 1, "permission": 1],
        "hr": ["empty": 1, "permission": 1],
        "img": ["empty": 1, "permission": 1],
        "input": ["empty": 1, "permission": 1],
        "isindex": ["empty": 1, "permission": 1],
        "param": ["empty": 1, "permission": 1]
    ] {
        get, set
    };

    protected validConfigurations = [
        "empty", "permission"
    ];

    /**
     * Verifies is a tag is in the whitelist of available tags
     * @param string tag
     *
     * @return boolean
     */
    public function isTagValid(const string tag) -> boolean
    {
        return isset(this->validHtmlElements[strtolower(tag)]);
    }

    /**
     * asserts if the element do not need/support a close tag
     *
     * @return boolean
     */
    public function isEmptyElement(string tag) -> boolean
    {
        return (isset(this->validHtmlElements[strtolower(tag)]["empty"])
            && this->validHtmlElements[strtolower(tag)]["empty"] == 1);
    }

    /**
     * asserts if the element as close tag
     *
     * @return boolean
     */
    public function isElementAllowed(string tag) -> boolean
    {
        return (isset(this->validHtmlElements[strtolower(tag)]["permission"])
                    && this->validHtmlElements[strtolower(tag)]["permission"] == 1);
    }

    /**
     * Adds a new html tag to the valid element tags, or configure an existing one
     * Note: if permission is not set, will automatically be set to 1
     *
     * @param string tagName
     * @param array config
     *
     * @return boolean
     */
    public function addHtmlElement(string tagName, config=[]) -> boolean
    {
        if !this->validateConfiguration(config) {
            return false;
        }

        var value, key;
        for key, value in config {
            let this->validHtmlElements[strtolower(tagName)][key] = value;
        }

        if !isset(this->validHtmlElements[strtolower(tagName)]["permission"]) {
            let this->validHtmlElements[strtolower(tagName)]["permission"] = 1;
        }

        return true;
    }

    /**
     * Validates that all given keys are available configurations
     *
     * @param array config
     *
     * @return boolean
     */
    protected function validateConfiguration(array config) -> boolean
    {
        var value;
        for value in config {
            if !in_array(value, this->validConfigurations) {
                return false;
            }
        }

        return true;
    }
}