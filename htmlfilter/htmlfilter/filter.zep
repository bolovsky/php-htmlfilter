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
     * @var array config
     */
    protected attributes = [] {
        set, get
    };

    /**
     * Holds the passed configuration
     * @var array config
     */
    protected replacers = ["&": "&amp;", "<": "&lt;", ">": "&gt;"] {
        get
    };

    protected parser;

    /**
     * Filters the passed string to clear any possible threats
     * @param string str
     * @return string
     */
    public function filterHtml(string! text) -> string
    {


        return text;
    }

    /**
     * Html parser to split inner html
     * @return Htmlfilter\Parser
     */
    protected function getParser() -> <\Htmlfilter\Parser>
    {
        if (this->parser == null) {
            let this->parser = new \Htmlfilter\Parser();
        }

        return this->parser;
    }
}