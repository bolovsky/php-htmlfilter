<?php

use \HtmlFilter\HtmlParser\Model\HtmlElement;
use \HtmlFilter\HtmlParser\Model\HtmlAttribute;

/**
 * Class FilterTest
 */
class FilterTest extends PHPUnit_Framework_TestCase
{
    /**
     * Full test scope on htmlfilter
     *
     * @param mixed $data
     * @param mixed $output
     * 
     * @dataProvider getFilteringData
     */
    public function testFiltering($data, $output)
    {
        $filter = new HtmlFilter\Filter();
        $result = $filter->filterHtml($data);
        $this->assertEquals($output, $result);
    }

    /**
     * Verifies the clearing of comments
     */
    public function testClearComments()
    {
        $filter = new HtmlFilter\Filter();
        $result = $filter->filterHtml("this should be cleaned<!--[if gte mso 9]><xml><w:WordDocument><![endif]-->");
        $this->assertEquals("this should be cleaned", $result);
    }

    /**
     * @param string $input
     * @param array $possibleOutputs
     * @param array $configuration
     *
     * @dataProvider getDataForElementConfig
     */
    public function testFilterConfigurationForHtmlElements(
        $input,
        $possibleOutputs,
        $configuration
    ) {
        $filter = new HtmlFilter\Filter();
        $result = $filter->filterHtml($input);
        $this->assertEquals($possibleOutputs['previousToConfig'], $result);

        $filter = new HtmlFilter\Filter($configuration);
        $result = $filter->filterHtml($input);
        $this->assertEquals($possibleOutputs['afterConfig'], $result);
    }

    /**
     * @param string $input
     * @param array $possibleOutputs
     * @param array $configuration
     *
     * @dataProvider getDataForAttributeConfig
     */
    public function testFilterConfigurationForElementAttributes(
        $input,
        $possibleOutputs,
        $configuration
    ) {
        $filter = new HtmlFilter\Filter();
        $result = $filter->filterHtml($input);
        $this->assertEquals($possibleOutputs['previousToConfig'], $result);

        $filter = new HtmlFilter\Filter($configuration);
        $result = $filter->filterHtml($input);
        $this->assertEquals($possibleOutputs['afterConfig'], $result);
    }

    /**
     * Data for a full scope test on Filter
     *
     * @return array
     */
    public function getFilteringData()
    {
        return array(
            'filter value normal string' => array(
                'valueInput' => 'the script tag must be removed<script>alert("test");</script>',
                'outputValue' => 'the script tag must be removed'
            ),
            'filter values with some nesting' => array(
                'valueInput' => '<span>this should have nothing more<script>exit();<\/script></span>',
                'outputValue' => '<span>this should have nothing more</span>'
            ),
            'filter values with xml nesting' => array(
                'valueInput' => 'New product<xml><test>test is this tags will be striped</test></xml>',
                'outputValue' => 'New product'
            ),
            'normal html, single tag, double attribute' => array(
                'valueInput' => '<span class="test" style="float: right;">test this</span>',
                'outputValue' => '<span class="test" style="float: right;">test this</span>',
            ),
            'normal html, single tag, double attribute, one is invalid' => array(
                'valueInput' => '<span class="test" onfocus="alert(1);">test this</span>',
                'outputValue' => '<span class="test">test this</span>',
            ),
        );
    }

    /**
     * @return array
     */
    public function getDataForElementConfig()
    {
        return array(
            'add new html tag, test previous and after' => array(
                'input' => "<span>this should always be visible</span><novalidelement>but this is only visible after config</novalidelement>",
                'output' => array(
                    'previousToConfig' => '<span>this should always be visible</span>',
                    'afterConfig' => '<span>this should always be visible</span><novalidelement>but this is only visible after config</novalidelement>'
                ),
                'configuration' => array(
                    'configureElements' => array(
                        'novalidelement' => array(HtmlElement::IS_ALLOWED => 1)
                    )
                )
            ),
            'disallow html tag, test previous and after' => array(
                'input' => "<span>this should only be visible befor config</span><div>but this is always visible</div>",
                'output' => array(
                    'previousToConfig' => '<span>this should only be visible befor config</span><div>but this is always visible</div>',
                    'afterConfig' => '<div>but this is always visible</div>'
                ),
                'configuration' => array(
                    'configureElements' => array(
                        'span' => array(HtmlElement::IS_ALLOWED => 0)
                    )
                )
            ),
            'allowing html tag as empty test previous and after' => array(
                'input' => '<div>but this is always visible</div><fakeinput class="but-this-after" />',
                'output' => array(
                    'previousToConfig' => '<div>but this is always visible</div>',
                    'afterConfig' => '<div>but this is always visible</div><fakeinput class="but-this-after" />'
                ),
                'configuration' => array(
                    'configureElements' => array(
                        'fakeinput' => array(HtmlElement::IS_ALLOWED => 1, HtmlElement::IS_EMPTY => 1)
                    )
                )
            ),
            'making class empty' => array(
                'input' => '<div>but this is always visible</div>',
                'output' => array(
                    'previousToConfig' => '<div>but this is always visible</div>',
                    'afterConfig' => '<div />but this is always visible'
                ),
                'configuration' => array(
                    'configureElements' => array(
                        'div' => array(HtmlElement::IS_ALLOWED => 1, HtmlElement::IS_EMPTY => 1)
                    )
                )
            ),
            'nestable elements removed' => array(
                'input' => '<span><div>should not be here after config</div></span>',
                'output' => array(
                    'previousToConfig' => '<span><div>should not be here after config</div></span>',
                    'afterConfig' => '<span></span>'
                ),
                'configuration' => array(
                    'configureElements' => array(
                        'span' => array(HtmlElement::IS_ALLOWED => 1, HtmlElement::IS_NESTABLE => 0)
                    )
                )
            ),
        );
    }

    /**
     * @return array
     */
    public function getDataForAttributeConfig()
    {
        return array(
            'add new html element attribute, test previous and after' => array(
                'input' => '<span novalidattribute="should-be-visible-after" onfocus="butThisShouldNot();">this should always be visible</span>',
                'output' => array(
                    'previousToConfig' => '<span>this should always be visible</span>',
                    'afterConfig' => '<span novalidattribute="should-be-visible-after">this should always be visible</span>'
                ),
                'configuration' => array(
                    'configureAttributes' => array(
                        'novalidattribute'=> array(HtmlAttribute::IS_ALLOWED => 1)
                    )
                )
            ),
            'disallow html element attribute, test previous and after' => array(
                'input' => '<span class="this-should-disappear">this should only be visible befor config</span>',
                'output' => array(
                    'previousToConfig' => '<span class="this-should-disappear">this should only be visible befor config</span>',
                    'afterConfig' => '<span>this should only be visible befor config</span>'
                ),
                'configuration' => array(
                    'configureAttributes' => array(
                        'class' => array(HtmlAttribute::IS_ALLOWED => 0)
                    )
                )
            )
        );
    }
}