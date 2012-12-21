<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:az="http://www.anthologize.org/ns" xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#default html az xd tei" version="1.0">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jul 29, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> Patrick Rashleigh</xd:p>
      <xd:p>A sample stylesheet to transform TEI to HTML for eventual ePub
        inclusion</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:output method="xml" encoding="UTF-8"/>
  <!--<xsl:variable name="images-directory" select="'OEBPS/images'"/>-->
  <xsl:variable name="images-directory" select="''"/>
  
  <xsl:variable name="anthologize-statement"
    select="'This electronic book was generated by Anthologize'"/>

  <!-- Load TEI data as global variables -->
  <xsl:include href="tei-data.xsl"/>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>
          <xsl:value-of select="$book.title"/>
        </title>
        <style type="text/css">
          <xsl:text>
            p { clear: both; }
            p+p { text-indent: 1.5em }
            @page { margin: 3cm }
            body {
              padding-top: 10em; 
          </xsl:text>
          
          <xsl:if test="$parameters.font-size != ''">          
            <xsl:value-of select="concat('&#xa;font-size:', $parameters.font-size, ';')"/>
          </xsl:if>

          <xsl:if test="$parameters.font-family != ''">
            <xsl:value-of select="concat('&#xa;font-family:', $parameters.font-family, ';')"/>
          </xsl:if>
          
          <xsl:text>
            }
            #anthologize-title-page
            {
              page-break-after: always;
            }
            #anthologize-title-page h1
            { 
              border-bottom: 0.3em solid #aaa;  
            }
            #publication-statement-page 
            { 
              page-break-after: always; padding-top: 10em; 
            }
            .anthologize-chapter-title 
            { 
              border-bottom: 1px solid black; 
              page-break-before: always;
              text-transform:uppercase;
              padding-bottom: 0.5em;
            }
            .anthologize-image-wrapper 
            {
              text-align: center;
              margin-top: 2em;
              margin-bottom: 2em;
            }
            
						div.back 
						{
						  page-break-before: always;
						}
						
            /* Wordpress styles */
            
            .alignright { float: right }
            .alignleft { float: left }
            
          </xsl:text>
        </style>
        <!--<link rel="stylesheet" type="application/vnd.adobe-page-template+xml"
          href="page-template.xpgt"/>-->
      </head>
      <body>

        <!-- Title page -->

        <div id="anthologize-title-page">
          <h1>
            <xsl:value-of select="$book.title-page.main-title"/>
          </h1>
          <xsl:if test="$book.title-page.sub-title != ''">
            <h2>
              <xsl:value-of select="$book.title-page.sub-title"/>
            </h2>
          </xsl:if>
          <xsl:if test="$book.title-page.doc-author != ''">
            <h3>
              <xsl:value-of select="$book.title-page.doc-author"/>
            </h3>
          </xsl:if>         
        </div>

        <!-- Publication statement page -->

        <div id="publication-statement-page">

          <!-- Dedication -->
          <!-- might be gremlins, but the convoluted string lenght normalize space was only way I got this to work right PMJ -->
          <xsl:if test="string-length( normalize-space( $book.dedication.text ) ) != 0">
            <h1>Dedication</h1>
            <div xml:id="anthologize-dedication">         
                <xsl:copy-of select="$book.dedication"/>              
            </div>
          </xsl:if>

          <!-- Title  -->

          <p>
            <strong>
              <xsl:value-of select="$book.title-page.main-title"/>
              <xsl:if test="$book.title-page.sub-title != ''">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$book.title-page.sub-title"/>
              </xsl:if>
            </strong>

            <br/>

            <!-- License statement -->

            <xsl:value-of select="$book.license"/>
          </p>

          <!-- Anthologize statement -->
	   
          <xsl:if test="$parameters.colophon = 'on'">      
          <p>
            <em>
              <xsl:value-of select="$anthologize-statement"/>
            </em>
          </p>
          </xsl:if>
        </div>

        <!-- Acknowledgements page -->

        <xsl:if test="string-length(normalize-space($book.acknowledgements.text) ) != 0 " >

          <div class="chapter" id="anthologize-acknowledgements-page">

            <!-- Heading: "Acknowledgements" -->

            <h2 class="anthologize-chapter-title">
              <xsl:value-of select="$book.acknowledgements.title"/>
            </h2>

            <!-- Acknowledgement text -->

            <div xml:id="chapter-content">
              <xsl:copy-of select="$book.acknowledgements"/>
            </div>
          </div>
        </xsl:if>

        <!-- Main content -->

        <!-- <div id="publication-statement"></div>-->
        <!-- <div class="book-description">
        <xsl:copy-of select="/TEI/teiHeader/fileDesc/sourceDesc"/> -->

        <xsl:for-each select="$blog.posts">
          <div class="chapter" id="epub-chapter-{position()}">
            <h2 class="anthologize-chapter-title">
                <xsl:element name="a">
                  <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                </xsl:element>            	
              <xsl:value-of select="tei:head/tei:title"/>
            </h2>
            <div class="chapter-content">
              <xsl:for-each select="tei:div[@type='libraryItem']">
                <xsl:element name="a">
                  <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                </xsl:element>
                <div class="library-item">
                  <xsl:if test="tei:head/tei:title">
                    <h3 class="library-item-title">
                      <xsl:value-of select="tei:head/tei:title"/>
                    </h3>
                  </xsl:if>
                  <div class="library-item-content">
                    <xsl:apply-templates select="div" mode="html-content"/>
                  </div>
                  <!--
              <p class="post-description">&#8594; Source: <span
                style="font-family: monospace"><xsl:value-of select="tei:link"
                /></span>, published on <xsl:value-of select="tei:pubDate"/> by
                  <xsl:value-of select="dc:creator"/>. </p>-->
                </div>
              </xsl:for-each>
            </div>
          </div>
        </xsl:for-each>
				
					
      </body>
    </html>
  </xsl:template>

  <!-- Skip through HTML body tags -->

  <xsl:template match="body" mode="html-content">
    <xsl:apply-templates mode="html-content"/>
  </xsl:template>

  <!-- Filter out script tags, but pass through noscript -->

  <xsl:template match="script" mode="html-content"/>
  <xsl:template match="noscript" mode="html-content">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="html-content"/>
    </xsl:copy>
  </xsl:template>

  <!-- Pass-through subset of XHTML that is recognised by ePub format -->

  <xsl:template
    match="abbr|acronym|address|blockquote|br|cite|code|dfn|div|em|h1|h2|h3|h4|h5|h6|kbd|p|pre|q|samp|span|strong|var|dl|dt|dd|ol|ul|li|a|object|param|b|big|hr|i|small|sub|sup|tt|del|ins|bdo|caption|col|colgroup|table|tbody|td|tfoot|th|thead|tr|area|map|style"
    mode="html-content">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="html-content"/>
    </xsl:copy>
  </xsl:template>

  <!-- Pass-through attributes of html tags and text nodes -->

  <xsl:template match="*/@*|node()" mode="html-content">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="html-content"/>
    </xsl:copy>
  </xsl:template>

  <!-- Object tag http://www.idpf.org/2007/ops/OPS_2.0_final_spec.html#Section2.3.6 
  
    When adding objects whose data media type is not drawn from the OPS Core Media Type list
    or which reference an object implementation using the classid attribute, 
    the object element must specify fallback information for the object, 
    such as another object, an img element, or descriptive text. 
    Inline fallback information is provided as OPS content appearing immediately after 
    the final param element that refers to the parent object. 
    Descriptive text for the object, using inline content, an included OPS Content Document, 
    or some other method, should be provided to allow access for people who are not able 
    to access non-textual content.
  
  -->

  <!-- FOR NOW: Pass through object tags -->

  <xsl:template match="object" mode="html-content">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="html-content"/>
    </xsl:copy>
  </xsl:template>

  <!--
  <xsl:template match="html:object">
    <xsl:if test="html:object"
  </xsl:template> -->

  <!--
    Wordpress wraps all images in anchor tags, which the epub format doesn't like.
    Strip all links from images
  -->

  <xsl:template match="a[img and count(.//*) = 1]" mode="html-content">
    <xsl:apply-templates mode="html-content"/>
  </xsl:template>

  <!-- Wrap images in a div -->
  <!-- (does this eliminate the xmlns attribute? If so, the regex can be taken out of the PHP page) -->

  <xsl:template match="img" mode="html-content">
    <div class="anthologize-image-wrapper">
      <img>
        <xsl:apply-templates select="@*" mode="html-content"/>
      </img>
    </div>
  </xsl:template>

  <!-- 
    Images have to have their URLs rewritten to make them relative and in the ePub image directory 
    take off everything before the LAST slash
  -->

  <xsl:template match="img/@src" mode="html-content">
    <xsl:attribute name="src">
      <xsl:variable name="img-url-filename-only">
        <xsl:call-template name="strip-url-of-directories">
          <xsl:with-param name="url" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat($images-directory, $img-url-filename-only)"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="strip-url-of-directories">
    <xsl:param name="url"/>
    <xsl:choose>
      <xsl:when test="contains($url,'/')">
        <xsl:call-template name="strip-url-of-directories">
          <xsl:with-param name="url" select="substring-after($url,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  <xsl:template name="get-author-info">
    <xsl:param name="author-id"/>
  </xsl:template>-->
</xsl:stylesheet>