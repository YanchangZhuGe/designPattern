package com.bgp.mcs.service.pm.service.common;

//import oracle.security.crypto.util.Utils;
//import oracle.security.xmlsec.enc.XECipherData;
//import oracle.security.xmlsec.enc.XEEncryptedKey;
//import oracle.security.xmlsec.enc.XEEncryptionMethod;
//import oracle.security.xmlsec.enc.XEKeyInfo;
//import oracle.security.xmlsec.saml.Assertion;
//import oracle.security.xmlsec.saml.AudienceRestrictionCondition;
//import oracle.security.xmlsec.saml.AuthenticationStatement;
//import oracle.security.xmlsec.saml.Conditions;
//import oracle.security.xmlsec.saml.NameIdentifier;
//import oracle.security.xmlsec.saml.SAMLInitializer;
//import oracle.security.xmlsec.saml.SAMLURI;
//import oracle.security.xmlsec.saml.Statement;
//import oracle.security.xmlsec.saml.Subject;
import oracle.security.xmlsec.util.Base64;
//import oracle.security.xmlsec.util.XMLURI;
import oracle.security.xmlsec.util.XMLUtils;
import oracle.security.xmlsec.wss.WSSecurity;
//import oracle.security.xmlsec.wss.WSSecurityTokenReference;
//import oracle.security.xmlsec.wss.WSUCreated;
//import oracle.security.xmlsec.wss.WSUExpires;
//import oracle.security.xmlsec.wss.WSUTimestamp;
//import oracle.security.xmlsec.wss.saml.SAMLAssertionToken;
import oracle.security.xmlsec.wss.soap.WSSOAPEnvelope;
import oracle.security.xmlsec.wss.username.UsernameToken;
//import oracle.security.xmlsec.wss.util.WSSEncryptionParams;
import oracle.security.xmlsec.wss.util.WSSTokenUtils;
//import oracle.security.xmlsec.wss.util.WSSUtils;
//import oracle.security.xmlsec.wss.util.WSSignatureParams;

import org.apache.cxf.binding.soap.SoapFault;
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.SoapVersion;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;

//import org.w3c.dom.Document;
import org.w3c.dom.Element;
//import org.w3c.dom.NodeList;

//import java.io.FileInputStream;
//import java.security.KeyStore;
//import java.security.PrivateKey;
//import java.security.PublicKey;
//import java.security.cert.X509Certificate;
//import java.util.ArrayList;
import java.util.Date;
//import java.util.List;
//
//import javax.crypto.KeyGenerator;
//import javax.crypto.SecretKey;
import javax.xml.soap.SOAPMessage;

public class P6WSOutInterceptor
  extends AbstractPhaseInterceptor<SoapMessage>
{
    //~ Static fields/initializers -----------------------------------------------------------------

//    private static final String WSSE_NAMESPACE = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
//    private static final String USERNAME_TOKEN = "UsernameToken";
//    private static final String SAML_ASSERTION = "Assertion";
//    private static final String ASSERTION_NAMESPACE = "urn:oasis:names:tc:SAML:1.0:assertion";
//
//    private static final String TIMESTAMP_ID_PREFIX = "Timestamp-";
//    private static final String SCHEMA_DATE_TIME = "http://www.w3.org/2001/XMLSchema/dateTime";
//    private static final String SAML_ISSUER = "http://your.saml.issuer.com";

    //~ Instance fields ----------------------------------------------------------------------------

    private P6WSPortTypeFactory.P6WSUser p6WSUser;

    //~ Constructors -------------------------------------------------------------------------------

    public P6WSOutInterceptor(P6WSPortTypeFactory.P6WSUser p6WSUser)
    {
        super(Phase.POST_MARSHAL);
        if(p6WSUser==null){
        	this.p6WSUser = P6WSPortTypeFactory.P6WSUser.DEFAULT_USER;
        }else{
        	this.p6WSUser = p6WSUser;
        }
    }

    //~ Methods ------------------------------------------------------------------------------------

    public void handleMessage(SoapMessage message)
      throws Fault
    {
        SoapVersion version = message.getVersion();

        try
        {
            SOAPMessage soapMessage = message.getContent(SOAPMessage.class);
            WSSOAPEnvelope wsEnvelope = new WSSOAPEnvelope(soapMessage.getSOAPPart().getEnvelope());

            // Create the Oracle WSSecurity element so we can add security information to SOAP header
            WSSecurity sec = WSSecurity.newInstance(wsEnvelope.getOwnerDocument());
            sec.setAttributeNS("http://schemas.xmlsoap.org/soap/envelope/", "mustUnderstand", "1");
            wsEnvelope.addSecurity(sec);

            // Remember information on the authentication elements so we can encrypt and sign them later
            String authTokenId = null;
//            String namespace = null;;
//            String name = null;

//            if (m_demoInfo.authMode == WSDemo.USERNAME_TOKEN_MODE)
//            {
                // Add the UsernameToken information, including Nonce token and Created time
                //  Also, store the WsuId so we can sign with it later, if encryption is enabled
                authTokenId = XMLUtils.randomName();
                addUsernameToken(sec, authTokenId);

                // Also store the namespace and name so we can load this element later
//                namespace = WSSE_NAMESPACE;
//                name = USERNAME_TOKEN;
//            }
//            else
//            {
//                // Add the SAML assertion information, and ignore the WsuId as we won't sign with it
//                //  Note: For SAML, we are acting as our own issuer, so the server must be configured to
//                //  accept the assertion sent by us (issuer: SAML_ISSUER (default: http://oracle.com/pgbu))
//                addSAMLAssertion(sec, wsEnvelope);
//
//                // Also store the namespace and name so we can load this element later
//                namespace = ASSERTION_NAMESPACE;
//                name = SAML_ASSERTION;
//            }

//            // Add Timestamp information to the header            
//            String rawTimestampId = addTimestamp(sec, wsEnvelope);
//
//            if (m_demoInfo.encEnabled || m_demoInfo.sigEnabled)
//            {
//                // To simplify the code in this demo, we will always sign and encrypt together, and we do that here
//                encryptAndSignMessage(sec, wsEnvelope, authTokenId, rawTimestampId, namespace, name);
//            }
        }
        catch (Exception ex)
        {
            throw new SoapFault("Error while creating security credentials.", ex, version.getSender());
        }
    }

    private Element addUsernameToken(WSSecurity sec, String wsuId)
    {
        // Create the basic UsernameToken information with the specified username and password
        UsernameToken unToken = WSSTokenUtils.createUsernameToken(wsuId, p6WSUser.username, null, null, p6WSUser.password.toCharArray());

        // A timestamp that the server checks to see if this message has taken too long to reach the server
        unToken.setCreatedDate(new Date());

        // A token to help prevent replay attacks
        //  If a second message with the same Nonce data is sent, it would be rejected by the server
        unToken.setNonce(Base64.fromBase64(XMLUtils.randomName()));

        sec.addUsernameToken(unToken);

        return unToken.getElement();
    }

//    private Element addSAMLAssertion(WSSecurity sec, WSSOAPEnvelope wsEnvelope)
//      throws Exception
//    {
//        SAMLInitializer.initialize(1, 1);
//
//        Document aDoc = wsEnvelope.getOwnerDocument();
//
//        // Create all the information that we need for our own SAML assertion
//        // And since we're acting as the identity provider, we also specify how the user authenticated
//        AuthenticationStatement statement = new AuthenticationStatement(aDoc);
//        statement.setAuthenticationMethod(SAMLURI.authentication_method_password);
//        statement.setAuthenticationInstant(new Date());
//        statement.setSubject(createSAMLSubject(aDoc, m_demoInfo.username));
//        String assertionId = XMLUtils.randomName();
//        Date notBefore = new Date();
//        Date notOnOrAfter = Utils.minutesFrom(notBefore, 5);
//
//        // Create the assertion element we need based on all the information above
//        Assertion assertion = createAssertion(aDoc, assertionId, SAML_ISSUER, notBefore, notOnOrAfter, SAML_ISSUER, statement);
//        SAMLAssertionToken samlToken = new SAMLAssertionToken(assertion);
//        sec.addSAMLAssertionToken(samlToken);
//
//        // Finally, to prove that the assertion that we're sending out is actually from the identity provider (us),
//        //  we can sign the message with our private key.
//        if (m_demoInfo.samlSigned)
//        {
//            // We just need to load the digital certificate and private key from the keystore specified
//            KeyStore keyStore = KeyStore.getInstance(m_demoInfo.samlKeystoreType);
//            keyStore.load(new FileInputStream(m_demoInfo.samlKeystore), m_demoInfo.samlKeystorepass.toCharArray());            
//            String privateKeyPassword = m_demoInfo.samlKeypass;
//            PrivateKey privateKey = (PrivateKey)keyStore.getKey(m_demoInfo.samlAlias, privateKeyPassword.toCharArray());
//
//            // And we can use the private key to sign our assertion, verifying that the message comes from us
//            assertion.sign(privateKey, null);
//        }
//
//        return assertion.getElement();
//    }

//    private static Subject createSAMLSubject(Document doc, String userName)
//    {
//        // Create the saml subject for the user we wish to login as
//        Subject subject = new Subject(doc);
//        NameIdentifier name = new NameIdentifier(doc);
//        name.setValue(userName);
//        subject.setNameIdentifier(name);
//
//        return subject;
//    }
//
//    private static Assertion createAssertion(Document doc, String assertionID, String issuer, Date notBefore, Date notOnOrAfter, String audience, Statement statement)
//      throws Exception
//    {
//        // Creates Assertion instance
//        Assertion assertion = new Assertion(doc);
//        assertion.setAssertionID(assertionID);
//        assertion.setIssuer(issuer);
//        assertion.setIssueInstant(new Date());
//        assertion.setVersion(1, 1);
//
//        // Creates Conditions element
//        Conditions cs = new Conditions(doc);
//        cs.setNotBefore(notBefore);
//        cs.setNotOnOrAfter(notOnOrAfter);
//
//        if (audience != null)
//        {
//            // Creates AudienceRestrictionCondition element
//            AudienceRestrictionCondition arc = new AudienceRestrictionCondition(doc);
//            arc.addAudience(audience);
//
//            // Appends arc to cs
//            cs.addCondition(arc);
//        }
//
//        // Appends cs to assertion
//        assertion.setConditions(cs);
//
//        // Appends statement to assertion
//        assertion.addStatement(statement);
//
//        return assertion;
//    }

//    private String addTimestamp(WSSecurity sec, WSSOAPEnvelope wsEnvelope)
//    {
//        WSUTimestamp timestamp = new WSUTimestamp(wsEnvelope.getOwnerDocument());
//        sec.setTimestamp(timestamp);
//
//        WSUCreated created = new WSUCreated(wsEnvelope.getOwnerDocument(), SCHEMA_DATE_TIME);
//        created.setValue(new Date());
//
//        WSUExpires expires = new WSUExpires(wsEnvelope.getOwnerDocument(), SCHEMA_DATE_TIME);
//        expires.setValue(Utils.minutesFrom(new Date(), 30));
//        timestamp.setCreated(created);
//        timestamp.setExpires(expires);
//
//        String rawTimestampId = TIMESTAMP_ID_PREFIX + XMLUtils.randomName();
//        WSSUtils.addWsuIdToElement(rawTimestampId, timestamp.getElement());
//
//        return rawTimestampId;
//    }

//    private void encryptAndSignMessage(WSSecurity sec, WSSOAPEnvelope wsEnvelope, String authTokenId, String timestampId, String namespace, String name)
//      throws Exception
//    {
//        // First we will get the relevant sections of the SOAP message, namely the AuthenticationToken and the Body of the message
//        NodeList nList = sec.getElementsByTagNameNS(namespace, name);
//        Element bodyElement = wsEnvelope.getBody();
//        Element authElement = (Element)nList.item(0);
//
//        // Next, we load the digital certificate the user specified earlier in the GUI
//        KeyStore keyStore = KeyStore.getInstance(m_demoInfo.keystoreType);
//        keyStore.load(new FileInputStream(m_demoInfo.keystore), m_demoInfo.keystorePass.toCharArray());
//        X509Certificate cert = (X509Certificate)keyStore.getCertificate(m_demoInfo.certAlias);
//        PublicKey publicKey = cert.getPublicKey();
//
//        // Create an encrypted key for use in creating the secret key
//        // Note: the secret key is the one used to actually encrypt the message,
//        // not this encrypted key
//        XEEncryptedKey ek = new XEEncryptedKey(wsEnvelope.getOwnerDocument());
//        XEEncryptionMethod em = ek.createEncryptionMethod(XMLURI.alg_rsaOAEP_MGF1);
//        em.setDigestMethod(XMLURI.alg_sha1);
//        ek.setEncryptionMethod(em);
//
//        // Generate the secret key which we will use to encrypt the message
//        // with a cryptographically valid source
//        SecretKey secretKey = KeyGenerator.getInstance("AES").generateKey();
//
//        // And then encrypt that key which the server's public key
//        byte[] cipherValue = ek.encrypt(secretKey, publicKey);
//        XECipherData cd = ek.createCipherData();
//        cd.setCipherValue(cipherValue);
//        ek.setCipherData(cd);
//
//        // Add the digital certificate data to the encrypted key
//        XEKeyInfo kki = ek.createKeyInfo();
//        kki.addKeyInfoData(kki.createX509Data(cert));
//
//        // Finally, we have all the information ready and we can the original message content
//        if (m_demoInfo.sigEnabled) 
//        {
//        	// Further, make sure that the WsuId is specified correctly so we can sign with these elements
//            String bodyId = "Body-" + XMLUtils.randomName();
//            WSSUtils.addWsuIdToElement(bodyId, wsEnvelope.getBody());
//            
//            // Create the Oracle objects with will allow us to sign the original message content
//            WSSignatureParams sigParams = new WSSignatureParams(secretKey.getEncoded(), null);
//            WSSecurityTokenReference str = sec.createSTR_EncKeySHA1(cipherValue);
//            sigParams.setKeyInfoData(str);
//
//            // Gather up the elements (the WsuIds specifically) that we will use to sign the original message content
//            List<String> wsuIds = new ArrayList<String>();
//            wsuIds.add("#" + bodyId);
//            wsuIds.add("#" + timestampId);
//            
//            // We only want to sign the authentication part of the header for username token
//            // For SAML, we allow the assertion to pass as is, and suggest that the identity provider should sign it
//            if (m_demoInfo.authMode != WSDemo.SAML_MODE)
//            {
//                wsuIds.add("#" + authTokenId);
//            }
//            
//        	String[] sigIdsArray = new String[wsuIds.size()];
//        	sec.sign(wsuIds.toArray(sigIdsArray), sigParams, null);
//        	
//        	if (!m_demoInfo.encEnabled)
//        	{
//        		sec.appendChild(ek);
//        	}
//        }
//
//        // And lastly, we can actually encrypt the message
//        if (m_demoInfo.encEnabled)
//        {
//            // Create the Oracle objects which will allow us to use the secret key above for encryption
//            WSSEncryptionParams params = new WSSEncryptionParams(XMLURI.alg_aes128_CBC, secretKey, null, null, null);
//            params.setKeyInfoData(sec.createSTR_EncKeySHA1(cipherValue));
//            params.setKeyEncryptionAlg(XMLURI.alg_rsaOAEP_MGF1);
//            params.setKeyEncryptionKey(publicKey);
//            
//        	// Gather up the elements that we wish to encrypt
//            List<Element> encryptElements = new ArrayList<Element>();
//            encryptElements.add(bodyElement);
//            encryptElements.add(authElement);
//            
//        	sec.encryptWithEncKey(encryptElements, new boolean[] {true, false}, null, params);
//        }
//
//        // Store this, and if the server is sending back encrypted messages, we can use this secret key then
//        DemoSecretKeyHolder.setSecretKey(secretKey);
//    }
}
