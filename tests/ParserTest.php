<?php

/**
 * Class ParserTest
 */
class ParserTest extends PHPUnit_Framework_TestCase
{
    /**
     * @var \HtmlFilter\HtmlParser
     */
    protected $htmlParser;

    /**
     * @{@inheritdoc}
     */
    public function setUp()
    {
        $this->htmlParser = new HtmlFilter\HtmlParser();
    }

    /**
     * Tests the htmlparser base return to check if
     * there was scrambling while reassembling the html together
     *
     * @param mixed $valueInput
     * @param mixed $outputValue
     * 
     * @dataProvider getDataHtmlProvider
     */
    public function testParserBaseReturn($valueInput, $outputValue)
    {
        $htmlArray = $this->htmlParser->parse(
            $valueInput
        );

        $out = "";
        foreach ($htmlArray as $element) {
            $out .= $element->getText();
        }

        $this->assertInternalType('array', $htmlArray);
        $this->assertEquals($outputValue,$out);
    }

    /**
     * Checks if attributes are properly "harvested"
     *
     * @param mixed $valueInput
     * @param mixed $outputValue
     *
     * @dataProvider getSampleHtmlValidTagsWithAttributes
     */
    public function testGetAttributesProperly($valueInput, $outputValue)
    {
        $htmlArray = $this->htmlParser->parse(
            $valueInput
        );

        foreach ($htmlArray as $key => $element) {
            if ($element instanceof \HtmlFilter\HtmlParser\HtmlTag) {
                $this->assertInternalType('array', $element->getAttributes());
                $this->assertEquals($outputValue[$key], $element->getAttributes());
            }
        }
    }

    /**
     * Html Data Provider
     *
     * @return array
     */
    public function getDataHtmlProvider()
    {
        return array(
            'normal html, single tag' => array(
                'valueInput' => '<span>test this</span>',
                'outputValue' => '<span>test this</span>'
            ),
            'normal html, nested tags' => array(
                'valueInput' => '<span>test this <strong>text</strong></span>',
                'outputValue' => '<span>test this <strong>text</strong></span>',
            ),
            'text first, normal html, single tag' => array(
                'valueInput' => 'this is some text<span>test this</span>',
                'outputValue' => 'this is some text<span>test this</span>',
            ),
            'text first, malformed html, single tag' => array(
                'valueInput' => 'this is some <text <spanan>test this</span>',
                'outputValue' => 'this is some test this',
            ),
            'some nesting' => array(
                'valueInput' => '<div><input><span>test this</span></div>',
                'outputValue' => '<div><input /><span>test this</span></div>',
            ),
            'normal html, single tag, single attribute' => array(
                'valueInput' => '<span class="test">test this</span>',
                'outputValue' => '<span class="test">test this</span>',
            ),
            'normal html, single tag, double attribute' => array(
                'valueInput' => '<span class="test" style="float: right;">test this</span>',
                'outputValue' => '<span class="test" style="float: right;">test this</span>',
            ),
            'normal html, nested tags, several attributes attribute' => array(
                'valueInput' => '<div class="outerDiv"><input type="text" name="mightyInput" /><span class="test" style="float: right;">test this</span></div>',
                'outputValue' => '<div class="outerDiv"><input type="text" name="mightyInput" /><span class="test" style="float: right;">test this</span></div>',
            ),
            'normal html, nested tags and invalid elements, several attributes attribute' => array(
                'valueInput' => '<div class="outerDiv"><invalidTag><input type="text" name="mightyInput" /></invalidTag><span class="test" style="float: right;">test this</span></div>',
                'outputValue' => '<div class="outerDiv"><input type="text" name="mightyInput" /><span class="test" style="float: right;">test this</span></div>',
            ),
        );
    }

    /**
     * Html with attributes provider
     *
     * @return array
     */
    public function getSampleHtmlValidTagsWithAttributes()
    {
        return array(
            'normal html, single tag, single attribute' => array(
                'valueInput' => '<span class="test">test this</span>',
                'outputValue' => array(
                    array('class="test"')
                ),
            ),
            'normal html, single tag, double attribute' => array(
                'valueInput' => '<span class="test" style="float: right;">test this</span>',
                'outputValue' => array(
                    array('class="test"', 'style="float: right;"')
                ),
            ),
            'normal html, nested tags, several attributes attribute' => array(
                'valueInput' => '<div class="outerDiv"><input type="text" name="mightyInput" /><span class="test" style="float: right;">test this</span></div>',
                'outputValue' => array(
                    array('class="outerDiv"'),
                    array('type="text"', 'name="mightyInput"'),
                    array('class="test"', 'style="float: right;"'),
                ),
            ),
        );
    }
}