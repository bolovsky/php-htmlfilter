<?php

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
     * @dataProvider getDataForConfig
     */
    public function testFilterConfigurationForHtmlElements($input, $possibleOutputs, $configuration)
    {
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
            )
        );
    }

    /**
     * @return array
     */
    public function getDataForConfig()
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
                        array('name'=>'novalidelement', 'permission' => 1)
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
                        array('name'=>'span', 'permission' => 0)
                    )
                )
            )
        );
    }
}