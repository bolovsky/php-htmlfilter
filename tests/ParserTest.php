<?php

class ParserTest extends PHPUnit_Framework_TestCase
{
    protected $parser;

    public function setUp()
    {
        $this->parser = new Htmlfilter\Parser();
    }

    /**
     * Tests the parser return
     *
     * @param mixed $data
     * @param mixed $output
     * 
     * @dataProvider getDataHtmlProvider
     */
    public function testParserBaseReturn($data, $output)
    {
        $response = $this->parser->parse(
            $data
        );

        $out = "";
        foreach ($response as $element) {
            $out .= $element->getText();
        }

        var_dump($out);

        $this->assertInternalType('array', $response);
        //$this->assetEquals($response, $output);
    }

    /**
     * Html Data Provider
     */
    public function getDataHtmlProvider()
    {
        return array(
            'normal html, single tag' => array(
                'valueInput' => '<span>test this</span>',
                'outputValue' => array()
            ),
            'normal html, nested tags' => array(
                'valueInput' => '<span>test this <strong>text</strong></span>',
                'outputValue' => array()
            ),
            'text first, normal html, single tag' => array(
                'valueInput' => 'this is some text<span>test this</span>',
                'outputValue' => array()
            ),
            'text first, malformed html, single tag' => array(
                'valueInput' => 'this is some <text <span>test this</span>',
                'outputValue' => array()
            ));
    } 
}