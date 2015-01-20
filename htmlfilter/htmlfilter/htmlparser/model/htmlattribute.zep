namespace HtmlFilter\HtmlParser\Model;

class HtmlAttribute extends HtmlModelAbstract
{
    const IS_ALLOWED = "permission";

    /**
     * Valid types of configurations allowed
     * {@inheritdoc}
     */
    protected validConfigurations = [
        self::IS_ALLOWED
    ];

    /**
     * @var array attributeBlacklist
     */
    protected attributePermissionList = [
        "class": ["permission": 1], 
        "name": ["permission": 1], 
        "id": ["permission": 0], 
        "style": ["permission": 1],
        "onfocus": ["permission": 0], 
        "onblur": ["permission": 0], 
        "onclick": ["permission": 0],
        "onsubmit": ["permission": 0],
        "src": ["permission": 1]
    ] {
        get, set
    };

    /**
     * Verifies that the html attribute exists and
     * is allowed in the attributePermissionList
     *
     * @param string attribute
     * @return boolean
     */
    public function isHtmlElementAttributeAllowed(string attribute) -> boolean
    {
        let attribute = strtolower(attribute);

        var splitAttribute = [];
        let splitAttribute = explode("=", attribute);

        let attribute = trim(splitAttribute[0]);

        return (isset(this->attributePermissionList[attribute])
                && this->attributePermissionList[attribute][self::IS_ALLOWED] == 1);
    }

    /**
     * Checks if the given tag as a matched pattern in attribute
     *
     * @param array attributes
     * @param string pattern
     * @return boolean
     */
    public function isPatternMatched(array attributes, string pattern) -> boolean
    {
        var attribute;
        var result = [];
        var_dump(attributes, pattern);
        //no pattern means no validation, and no generic rules
        if !pattern {
            return true;
        }

        for attribute in attributes {
            preg_match(attribute, pattern, result);

            if count(result) > 0 {
                return true;
            }
        }

        return false;
    }

    /**
     * Adds a new html element attribute to the valid element attribute, or configure an existing one
     * Note: if permission is not set, will automatically be set to 1
     *
     * @param string attributeName
     * @param array config
     *
     * @return boolean
     */
    public function addHtmlElementAttribute(
        string attribute,
        array config=[]
    ) -> boolean {

        if !this->validateConfiguration(config) {
            return false;
        }

        var value, key;
        let attribute = strtolower(attribute);
        for key, value in config {
            let this->attributePermissionList[attribute][key] = value;
        }

        if !isset(this->attributePermissionList[attribute][self::IS_ALLOWED]) {
            let this->attributePermissionList[attribute][self::IS_ALLOWED] = 1;
        }

        return true;
    }
}