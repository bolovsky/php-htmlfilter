namespace HtmlFilter\Parser;

/**
 * Class PlainText
 */
class PlainText extends AbstractText
{
    /**
     * Creates a new plain text object
     *
     * @param string tag
     */
    public function __construct(string! text)
    {
        let this->innerText = text;
    }

    /**
     * {@inheritdoc}
     */
    public function getText() -> string
    {
        return this->getInnerText();
    }
}