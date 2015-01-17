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
         "onsubmit": 0
    ] {
        get, set
    };

    /**
     * Verifies that the html attribute exists and
     * is allowed in the attributePermissionList
     *
     * @param string attribute
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