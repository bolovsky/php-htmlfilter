namespace HtmlFilter\HtmlParser\Model;

abstract class HtmlModelAbstract
{
    /**
     * Valid types of configurations allowed
     *
     */
    protected validConfigurations = [];

    /**
     * Validates that all given keys are available configurations
     *
     * @param array config
     *
     * @return boolean
     */
    protected function validateConfiguration(array config) -> boolean
    {
        var key;
        for key, _ in config {
            if !in_array(key, this->validConfigurations) {
                return false;
            }
        }

        return true;
    }
}