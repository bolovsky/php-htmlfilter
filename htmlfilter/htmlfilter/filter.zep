namespace HtmlFilter;

/**
 * filters HTML according to the set of provided rules
 *
 */
class Filter
{
    /**
     * Holds the passed configuration
     * @var array config
     */
    protected config = [] {
        set, get
    };

    /**
     * List of valid html elements
     * @var array htmlElements
     */
    protected htmlElements = [] {
        set, get
    };

    /**
     * list of valid attributes
     * @var array attributes
     */
    protected attributes = [] {
        set, get
    };

    /**
     * Holds the regular replacers fo html "dangerous" chars
     * @var array replacers
     */
    protected replacers = ["&": "&amp;", "<": "&lt;", ">": "&gt;"] {
        get
    };

    /**
     * @var <HtmlFilter\HtmlParser>
     */
    protected parser;

    /**
     * @var boolean allowComments
     */
    protected allowComments = false {
        get, set
    };

    /**
     * @var array elementBlacklist
     */
    protected elementPermissionList = [
        "span": 1, "div": 1, "iframe": 1, "p": 1,
        "strong": 1, "applet": 0, "video": 1, "small": 1,
        "noscript": 1, "form": 1, "button": 1, "a": 1, "dt": 1,
        "del": 1, "dd": 1, "fieldset": 1, "script": 0, "em": 1,
        "ins": 1, "li": 1, "object": 1, "b": 1, "bdo": 1,
        "td": 1, "th": 1, "abbr": 1, "acronym": 1, "address": 1,
        "big": 1, "caption": 1, "cite": 1, "code": 1, "dfn": 1,
        "font": 1, "h1: 1", "h2": 1, "h3": 1, "h4": 1, "h5": 1,
        "h6": 1, "i": 1, "kbd": 1, "label": 1, "legend": 1,
        "pre": 1, "q": 1, "rb": 1, "rt": 1, "s": 1, "samp": 1,
        "span": 1, "strike": 1,"sub": 1, "sup": 1, "tt": 1,
        "u": 1, "var": 1, "blockquote": 1, "map": 1, "input": 1
    ] {
        get, set
    };

    /**
     * @var array attributeBlacklist
     */
    protected attributePermissionList = [
        "class": 1, "name": 1, "id": 0, "style": 1,
        "onfocus": 0, "onblur": 0, "onclick": 0, "onsubmit": 0
    ] {
        get, set
    };

    /**
     * @param array config
     * @param boolean allowComments
     */
    public function __construct(array config=[], boolean! allowComments=false)
    {
        let this->allowComments = allowComments;
        let this->config = config;
    }

    /**
     * Filters the passed string to clear any possible threats
     * @param string str
     * @return string
     */
    public function filterHtml(string! htmlString) -> string
    {
        let htmlString = this->clearComments(htmlString);
        let htmlString = this->clearOddChars(htmlString);

        var parsedHtml;
        let parsedHtml = this->getParser()->parse(htmlString);
        let parsedHtml = this->cleanTags(parsedHtml);

        var cleanHtmlString = "";
        var tag;
        for tag in parsedHtml {
            let cleanHtmlString .= tag->getText();
        }

        return cleanHtmlString;
    }

    /**
     * Clears the malicious code from html tags
     *
     * @param array parsedHtml
     *
     * @return array
     */
    protected function cleanTags(parsedHtml) -> array
    {
        if empty(parsedHtml) {
            return parsedHtml;
        }

        var tag;
        var cleanedHtmlTags = [];

        for tag in parsedHtml {
            if tag instanceof \HtmlFilter\HtmlParser\HtmlTag {
                if !this->isHtmlElementAllowed(tag->getTag()) {
                    continue;
                }

                var cleanAttributes = [];
                var attribute;
                for attribute in tag->getAttributes() {
                    if this->isHtmlElementAttributeAllowed(attribute) {
                        let cleanAttributes[] = attribute;
                    }
                }

                if tag->hasChildren() {
                    tag->setChildren(
                        this->cleanTags(
                            tag->getChildren()
                        )
                    );
                }

                tag->setAttributes(
                    cleanAttributes
                );
            }

            let cleanedHtmlTags[] = tag;
        }

        return cleanedHtmlTags;
    }

    /**
     * Removes bad attributes and cleans the remaining ones
     *
     * @param array parsedAttributes
     * @return array
     */
    protected function cleanAttributes(array parsedAttributes)
    {
        return parsedAttributes;
    }

    /**
     * Html parser to split inner html
     *
     * @return Htmlfilter\Parser
     */
    protected function getParser() -> <\HtmlFilter\HtmlParser>
    {
        if (this->parser == null) {
            let this->parser = new \HtmlFilter\HtmlParser();
        }

        return this->parser;
    }

    /**
     * Clear html comments or CDATA sections
     * @param string text
     *
     * @return string
     */
    protected function clearComments(string! text)
    {
        if !this->getAllowComments() {
            let text = preg_replace(
                "`<!(?:(?:--.*?--)|(?:\[CDATA\[.*?\]\]))>`sm",//" @fixme remove this, the syntax highlight is not working properly cause of some chars
                "",
                text
            );
        }

        return text;
    }

    /**
     * Removes Odd chars, usually created by ms-word
     *
     * @param string text
     * @return string
     */
    protected function clearOddChars(string! text)
    {
        let text = preg_replace("`[\\x00-\\x08\\x0b-\\x0c\\x0e-\\x1f]`", "", text);

        if isset(this->config["clean_ms_char"]) {
            var exclude = [
                "\x7f" : "", "\x80" : "&#8364;", "\x81" : "", 
                "\x83" : "&#402;", "\x85" : "&#8230;", "\x86" : "&#8224;",
                "\x87" : "&#8225;", "\x88" : "&#710;", "\x89" : "&#8240;", 
                "\x8a" : "&#352;", "\x8b" : "&#8249;", "\x8c" : "&#338;", 
                "\x8d" : "", "\x8e" : "&#381;", "\x8f" : "", "\x90" : "", 
                "\x95" : "&#8226;", "\x96" : "&#8211;", "\x97" : "&#8212;", 
                "\x98" : "&#732;", "\x99" : "&#8482;", "\x9a" : "&#353;", 
                "\x9b" : "&#8250;", "\x9c" : "&#339;", "\x9d" : "", 
                "\x9e" : "&#382;", "\x9f" : "&#376;"
            ];

            var key;
            var value;

            if this->config["clean_ms_char"] == 1 {
                for key, value in [
                    "\x82" : "&#8218;", "\x84" : "&#8222;", "\x91" : "&#8216;", 
                    "\x92" : "&#8217;", "\x93" : "&#8220;", "\x94" : "&#8221;"
                ] {
                    let exclude[key] = value;
                }
            } else {
                for key, value in ["\x82" : "'", "\x84" : "\"", "\x91" : "'", "\x92" : "'", "\x93" : "\"", "\x94" : "\""]
                {
                    let exclude[key] = value;
                }
            }
            
            let text = strtr(text, exclude);
        }

        return text;
    }

    /**
     * Verifies that the html element exists and
     * is allowed in the elementPermissionList
     *
     * @param string tag
     */
    public function isHtmlElementAllowed(string! tagName) -> boolean
    {
        let tagName = strtolower(tagName);
        return (isset(this->elementPermissionList[tagName])
                && this->elementPermissionList[tagName] === 1);
    }

    /**
     * Verifies that the html attribute exists and
     * is allowed in the attributePermissionList
     *
     * @param string attribute
     */
    public function isHtmlElementAttributeAllowed(string! attribute) -> boolean
    {
        let attribute = strtolower(attribute);

        var splitAttribute = [];
        let splitAttribute = explode("=", attribute);

        let attribute = trim(splitAttribute[0]);

        return (isset(this->attributePermissionList[attribute])
                && this->attributePermissionList[attribute] === 1);
    }
}