namespace Htmlfilter\Parser;

abstract class AbstractText implements TextInterface
{
    /**
     * Text inside the element
     * @var string innerText
     */
    protected innerText = "" {
        get, set
    };
}