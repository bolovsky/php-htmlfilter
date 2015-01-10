<?php

/**
 * Class FilterTest
 */
class FilterTest extends PHPUnit_Framework_TestCase
{
    /**
     * @var \HtmlFilter\Filter
     */
    protected $filter;

    /**
     * @{@inheritdoc}
     */
    public function setUp()
    {
        $this->filter = new HtmlFilter\Filter();
    }

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
        $result = $this->filter->filterHtml($data);
        $this->assertEquals($output, $result);
    }

    /**
     * Verifies the clearing of comments
     */
    public function testClearComments()
    {
        $result =$this->filter->filterHtml("this should be cleaned<!--[if gte mso 9]><xml><w:WordDocument><![endif]-->");
        $this->assertEquals("this should be cleaned", $result);
    }

    /**
     * Data for a full scope test on Filter
     *
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
}