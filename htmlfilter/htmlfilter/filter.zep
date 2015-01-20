namespace HtmlFilter;

/**
 * filters HTML according to the set of provided rules
 *
 */
class Filter
{
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
     * @var boolean cleanMSCharacters
     */
    protected cleanMSCharacters = false {
       get, set
    };

    /**
     * @var HtmlFilter\HtmlParser\Model\HtmlElement htmlElement
     */
    protected htmlElement;


    /**
     * @var HtmlFilter\HtmlParser\Model\HtmlAttribute htmlAttribute
     */
    protected htmlAttribute;

    /**
     * @param array config
     * @param boolean allowComments
     */
    public function __construct(array config=[])
    {
        this->handleConfig(config);
    }

    /**
     * Manages filter initial configuration
     *
     * @param array config
     */
    protected function handleConfig(array config)
    {
        if isset(config["allowComments"]) {
            this->setAllowComments(config["allowComments"]);
        }

        if isset(config["configureElements"]) {
            this->configureElements(config["configureElements"]);
        }

        if isset(config["configureAttributes"]) {
            this->configureAttributes(config["configureAttributes"]);
        }

        if isset(config["cleanMSCharacters"]) {
            this->setCleanMSCharacters(config["cleanMSCharacters"]);
        }
    }

    /**
     * Filters the passed string to clear any possible threats
     * @param string str
     * @return string
     */
    public function filterHtml(string! htmlString) -> string
    {
        let htmlString = this->clearComments(htmlString);
        let htmlString = this->clearMSChars(htmlString);

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

                if tag->getTag() == "iframe" {
                    var_dump(this->getHtmlElement()->getPatternToMatch(tag->getTag()));
                }

                //this checks if a pattern was provided and if it is followed
                if this->getHtmlElement()->getPatternToMatch(tag->getTag())
                    && !this->getHtmlAttribute()->isPatternMatched(
                        cleanAttributes,
                        this->getHtmlElement()->getPatternToMatch(tag->getTag())
                    )
                {
                    continue;
                }

                echo "yeah, here, \n";

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
            let this->parser = new \HtmlFilter\HtmlParser(
                this->getHtmlElement()
            );
        }

        return this->parser;
    }

    /**
     * Html Element model
     *
     * @return HtmlFilter\HtmlParser\Model\HtmlElement
     */
    protected function getHtmlElement() -> <\HtmlFilter\HtmlParser\Model\HtmlElement>
    {
        if (this->htmlElement == null) {
            let this->htmlElement = new \HtmlFilter\HtmlParser\Model\HtmlElement();
        }

        return this->htmlElement;
    }

    /**
     * Html Attribute model
     *
     * @return HtmlFilter\HtmlParser\Model\HtmlAttribute
     */
    protected function getHtmlAttribute() -> <\HtmlFilter\HtmlParser\Model\HtmlAttribute>
    {
        if (this->htmlAttribute == null) {
            let this->htmlAttribute = new \HtmlFilter\HtmlParser\Model\HtmlAttribute();
        }

        return this->htmlAttribute;
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
     * Removes Odd chars, usually created by ms-word/excel..
     *
     * @param string text
     * @return string
     */
    protected function clearMSChars(string! text)
    {
        let text = preg_replace("`[\\x00-\\x08\\x0b-\\x0c\\x0e-\\x1f]`", "", text);

        if this->cleanMSCharacters {
            var exclude = [
                "\x7f" : "", "\x80" : "&#8364;", "\x81" : "", 
                "\x83" : "&#402;", "\x85" : "&#8230;", "\x86" : "&#8224;",
                "\x87" : "&#8225;", "\x88" : "&#710;", "\x89" : "&#8240;", 
                "\x8a" : "&#352;", "\x8b" : "&#8249;", "\x8c" : "&#338;", 
                "\x8d" : "", "\x8e" : "&#381;", "\x8f" : "", "\x90" : "", 
                "\x95" : "&#8226;", "\x96" : "&#8211;", "\x97" : "&#8212;", 
                "\x98" : "&#732;", "\x99" : "&#8482;", "\x9a" : "&#353;", 
                "\x9b" : "&#8250;", "\x9c" : "&#339;", "\x9d" : "",
                "\x9e" : "&#382;", "\x9f" : "&#376;","\x82" : "&#8218;",
                "\x92" : "&#8217;", "\x93" : "&#8220;", "\x94" : "&#8221;",
                "\x84" : "&#8222;", "\x91" : "&#8216;"
            ];
            
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
        return this->getHtmlElement()
            ->isElementAllowed(tagName);
    }

    /**
     * Verifies that the html attribute exists and
     * is allowed in the attributePermissionList
     *
     * @param string attribute
     */
    public function isHtmlElementAttributeAllowed(string! attribute) -> boolean
    {
        return this->getHtmlAttribute()
            ->isHtmlElementAttributeAllowed(attribute);
    }

    /**
     * Receives an configuration array for html elements
     * Elements that do not exist will be created.
     * If permission is not set, defaults to activate.
     *
     * @param array elements
     *
     * @return boolean
     *
     * @example
     * [
     *    ["name" => "script", "permission" => 0],
     *    ["name" => "aside", "permission" => 1]
     * ]
     *
     */
    public function configureElements(array elements) -> boolean
    {
        if count(elements) == 0 {
            return false;
        }

        var element, elementName;
        for elementName, element in elements {
            if !this->getHtmlElement()->addHtmlElement(elementName, element) {
                return false;
            }
        }

        return true;
    }

    /**
     * Receives an configuration array for html element attributes
     * Attributes that do not exist will be created.
     * If permission is not set, defaults to activate.
     *
     * @param array elements
     *
     * @return boolean
     *
     * @example
     * [
     *    ["name" => "src", "permission" => 1],
     *    ["name" => "onfocus", "permission" => 0]
     * ]
     */
    public function configureAttributes(array attributes) -> boolean
    {
        if count(attributes) == 0 {
            return false;
        }

        var attributeName, attribute;
        for attributeName, attribute in attributes {
            let attributeName = strtolower(attributeName);

            if !this->getHtmlAttribute()->addHtmlElementAttribute(attributeName, attribute) {
                return false;
            }
        }

        return true;
    }
}