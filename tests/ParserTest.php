<?php

class ParserTest extends PHPUnit_Framework_TestCase
{
    protected $parser;

    public function setUp()
    {
        $this->parser = new HtmlFilter\Parser();
    }

    /**
     * Tests the parser return
     *
     * @param mixed $valueInput
     * @param mixed $outputValue
     * 
     * @dataProvider getDataHtmlProvider
     */
    public function testParserBaseReturn($valueInput, $outputValue)
    {
        $response = $this->parser->parse(
            $valueInput
        );

        $out = "";
        foreach ($response as $element) {
            $out .= $element->getText();
        }

        $this->assertInternalType('array', $response);
        $this->assertEquals($outputValue,$out);
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
        );
    } 
}