namespace Htmlfilter;

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

    protected parser;

    protected allowComments = false {
        get, set
    };

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
    public function filterHtml(string! text) -> string
    {
        let text = this->clearComments(text);
        let text = this->clearOddChars(text);

        return text;
    }

    /**
     *
     */
    protected function cleanTags()
    {

    }

    /**
     * Html parser to split inner html
     *
     * @return Htmlfilter\Parser
     */
    protected function getParser() -> <\Htmlfilter\Parser>
    {
        if (this->parser == null) {
            let this->parser = new \Htmlfilter\Parser();
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
                "`<!(?:(?:--.*?--)|(?:\[CDATA\[.*?\]\]))>`sm",
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
}