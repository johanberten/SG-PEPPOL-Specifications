<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt2">
	<title>EN16931 Conformant Singapore model bound to UBL</title>
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
	<ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
	<ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
	<phase id="EN16931model_phase" >
		<active pattern="UBL-model"/>
	</phase>
	<phase id="codelist_phase">
		<active pattern="Codesmodel"/>
	</phase>
	<!--Suppressed abstract pattern model was here-->
	<!--Suppressed abstract pattern syntax was here-->
	<!--Start pattern based on abstract model-->
	<pattern id="UBL-model">
		<rule context="cac:LegalMonetaryTotal">
			<assert test="exists(cbc:TaxExclusiveAmount)" flag="fatal" id="BR-13-GST-SG">[BR-13-GST-SG]-An Invoice shall have the Invoice total amount without GST (BT-109-GST).</assert>
			<assert test="exists(cbc:TaxInclusiveAmount)" flag="fatal" id="BR-14-GST-SG">[BR-14-GST-SG]-An Invoice shall have the Invoice total amount with GST (BT-112-GST).</assert>
			
			<assert test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))" flag="fatal" id="BR-CO-13-GST-SG">[BR-CO-13-GST-SG]-Invoice total amount without GST (BT-109-GST) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</assert>
			<assert test="(xs:decimal(cbc:PrepaidAmount) and not(xs:decimal(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(xs:decimal(cbc:PrepaidAmount)) and not(xs:decimal(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (xs:decimal(cbc:PrepaidAmount) and xs:decimal(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(xs:decimal(cbc:PrepaidAmount)) and xs:decimal(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount))) " flag="fatal" id="BR-CO-16-GST-SG">[BR-CO-16-GST-SG]-Amount due for payment (BT-115) = Invoice total amount with GST (BT-112-GST-SG) -Paid amount (BT-113) +Rounding amount (BT-114).</assert>
			<assert test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2" flag="fatal" id="BR-DEC-12-GST-SG">[BR-DEC-12-GST-SG]-The allowed maximum number of decimals for the Invoice total amount without GST (BT-109-GST) is 2.</assert>
			<assert test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2" flag="fatal" id="BR-DEC-14-GST-SG">[BR-DEC-14-GST-SG]-The allowed maximum number of decimals for the Invoice total amount with GST (BT-112-GST) is 2.</assert>
		</rule>
		<rule context="//ubl:Invoice | //cn:CreditNote">
			<assert test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])" flag="fatal" id="BR-53-GST-SG">[BR-53-GST-SG]-If the GST accounting currency code (BT-6-GST) is present, then the Invoice total GST amount in accounting currency (BT-111-GST) shall be provided.</assert>
			<assert test="every $Currency in cbc:DocumentCurrencyCode satisfies cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100" flag="fatal" id="BR-CO-15-GST-SG">[BR-CO-15-GST-SG]-Invoice total amount with GST (BT-112-GST) = Invoice total amount without GST (BT-109-GST) + Invoice total GST amount (BT-110-GST).</assert>
			<assert test="exists(cac:TaxTotal/cac:TaxSubtotal)" flag="fatal" id="BR-CO-18-GST-SG">[BR-CO-18-GST-SG]-An Invoice shall at least have one GST Breakdown group (BG-23-GST).</assert>
			<assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))" flag="fatal" id="BR-DEC-13-GST-SG">[BR-DEC-13-GST-SG]-The allowed maximum number of decimals for the Invoice total GST amount (BT-110-GST) is 2.</assert>
			<assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))" flag="fatal" id="BR-DEC-15-GST-SG">[BR-DEC-15-GST-SG]-The allowed maximum number of decimals for the Invoice total GST amount in accounting currency (BT-111-GST) is 2.</assert>
			<!-- NG-GST rules -->
			<assert id="BR-NG-01-GST-SG" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']))">[BR-NG-01-GST-SG]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the GST category code (BT-151-GST, BT-95-GST or BT-102-GST) is "NG" shall contain exactly one GST breakdown group (BG-23) with the GST category code (BT-118) equal to "NG".</assert>
			<assert id="BR-NG-02-GST-SG" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'])">[BR-NG-02-GST-SG]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item GST category code (BT-151-GST) is "NG" shall not contain the Seller GST identifier (BT-31), the Seller tax representative GST identifier (BT-63-GST) or the Buyer GST identifier (BT-48-GST).</assert>
			<assert id="BR-NG-03-GST-SG" flag="fatal" test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']))">[BR-NG-03-GST-SG]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance GST category code (BT-95-GST) is "NG" shall not contain the Seller GST identifier (BT-31-GST), the Seller tax representative GST identifier (BT-63-GST) or the Buyer GST identifier (BT-48-GST).</assert>
			<assert id="BR-NG-04-GST-SG" flag="fatal" test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']))">[BR-NG-04-GST-SG]-An Invoice that contains a Document level charge (BG-21) where the Document level charge GST category code (BT-102-GST) is "NG" shall not contain the Seller GST identifier (BT-31-GST), the Seller tax representative GST identifier (BT-63-GST) or the Buyer GST identifier (BT-48-GST).</assert>
			<assert id="BR-NG-11-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-11-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118-GST) "NG" shall not contain other GST breakdown groups (BG-23).    </assert>
			<assert id="BR-NG-12-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-12-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118) "NG" shall not contain an Invoice line (BG-25) where the Invoiced item GST category code (BT-151-GST) is not "NG".</assert>
			<assert id="BR-NG-13-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-13-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118-GST) "NG" shall not contain Document level allowances (BG-20) where Document level allowance GST category code (BT-9-GST5) is not "NG".</assert>
			<assert id="BR-NG-14-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-14-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118-GST) "NG" shall not contain Document level charges (BG-21) where Document level charge GST category code (BT-102-GST) is not "NG".</assert>
		</rule>
<!--		<rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']">
			<assert id="BR-NG-05-GST-SG" flag="fatal" test="not(cbc:Percent)">[BR-NG-05-GST-SG]-An Invoice line (BG-25) where the GST category code (BT-151-GST) is "NG" shall not contain an Invoiced item GST rate (BT-152-GST).</assert>
		</rule>
		<rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']">
			<assert id="BR-NG-06-GST-SG" flag="fatal" test="not(cbc:Percent)">[BR-NG-06-GST-SG]-A Document level allowance (BG-20) where GST category code (BT-95-GST) is "NG" shall not contain a Document level allowance GST rate (BT-96-GST).</assert>
		</rule>
		<rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']">
			<assert id="BR-NG-07-GST-SG" flag="fatal" test="not(cbc:Percent)">[BR-NG-07-GST-SG]-A Document level charge (BG-21) where the GST category code (BT-102-GST) is "NG" shall not contain a Document level charge GST rate (BT-103-GST).</assert>
		</rule>
-->
		<rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']">
			<assert id="BR-NG-08-GST-SG" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount)))))">[BR-NG-08]-In a GST breakdown (BG-23) where the GST category code (BT-118-GST) is "NG" the GST category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the GST category codes (BT-151-GST, BT-95-GST, BT-102-GST) are "NG".</assert>
			<assert id="BR-NG-09-GST-SG" flag="fatal" test="../cbc:TaxAmount = 0">[BR-NG-09-GST-SG]-The GST category tax amount (BT-117-GST) in a GST breakdown (BG-23) where the GST category code (BT-118-GST) is "NG" shall be 0 (zero).</assert>
		</rule>
		<rule context="cac:InvoiceLine | cac:CreditNoteLine">
		
			<assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" flag="fatal" id="BR-CO-04-GST-SG">[BR-CO-04-GST-SG]-Each Invoice line (BG-25) shall be categorized with an Invoiced item GST category code (BT-151-GST).</assert>
		</rule>
		
		<rule context="cac:AccountingSupplierParty">
			<assert test="exists(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" flag="fatal" id="BR-CO-26-GST-SG">[BR-CO-26-GST-SG]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller GST identifier (BT-31-GST) shall be present.</assert>
		</rule>
		
		<rule context="cac:TaxRepresentativeParty">
			<assert test="exists(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'GST']/cbc:CompanyID)" flag="fatal" id="BR-56-GST-SG">[BR-56-GST-SG]-Each Seller tax representative party (BG-11) shall have a Seller tax representative GST identifier (BT-63-GST).</assert>
		</rule>
		<rule context="//ubl:Invoice/cac:TaxTotal | //cn:CreditNote/cac:Taxtotal">
			<assert test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)" flag="fatal" id="BR-CO-14-GST-SG">[BR-CO-14-GST-SG]-Invoice total GST amount (BT-110-GST) = Σ GST category tax amount (BT-117-GST).</assert>
		</rule>
		<rule context="cac:TaxTotal/cac:TaxSubtotal">
			<assert test="exists(cbc:TaxableAmount)" flag="fatal" id="BR-45-GST-SG">[BR-45-GST-SG]-Each GST Breakdown (BG-23-GST) shall have a GST category taxable amount (BT-116-GST).</assert>
			<assert test="exists(cbc:TaxAmount)" flag="fatal" id="BR-46-GST-SG">[BR-46-GST-SG]-Each GST Breakdown (BG-23-GST) shall have a GST category tax amount (BT-117-GST).</assert>
			<assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" flag="fatal" id="BR-47-GST-SG">[BR-47-GST-SG]-Each GST Breakdown (BG-23-GST) shall be defined through a GST category code (BT-118-GST).</assert>
			<assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent) or (normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)='')" flag="fatal" id="BR-48-GST-SG">[BR-48-GST-SG]-Each GST breakdown (BG-23-GST) shall have a GST category rate (BT-119-GST), except if the Invoice is not subject to GST.</assert>
			<assert test="(round(cac:TaxCategory/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and (xs:decimal(cbc:TaxAmount) = round(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )) or (not(exists(cac:TaxCategory/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))" flag="fatal" id="BR-CO-17-GST-SG">[BR-CO-17-GST-SG]-GST category tax amount (BT-117-GST) = GST category taxable amount (BT-116-GST) x (GST category rate (BT-119-GST) / 100), rounded to two decimals.</assert>
			<assert test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2" flag="fatal" id="BR-DEC-19-GST-SG">[BR-DEC-19-GST-SG]-The allowed maximum number of decimals for the GST category taxable amount (BT-116-GST) is 2.</assert>
			<assert test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2" flag="fatal" id="BR-DEC-20-GST-SG">[BR-DEC-20-GST-SG]-The allowed maximum number of decimals for the GST category tax amount (BT-117-GST) is 2.</assert>
		</rule>
	</pattern>
	<!--Start pattern based on abstract syntax-->
	<pattern id="UBL-syntax">
		
		<rule context="/ubl:Invoice">
			
			<assert test="not(cac:PaymentMeans/cac:PayerFinancialAccount)" flag="warning" id="UBL-CR-423">[UBL-CR-423]-A UBL invoice should not include the PaymentMeans PayerFinancialAccount</assert>
			
			<assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='GST']/cbc:CompanyID) &lt;= 1)" flag="warning" id="UBL-SR-12-GST_SG">[UBL-SR-12-GST-SG]-Seller GST identifier shall occur maximum once</assert>
			<assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID!='GST']/cbc:ID) &lt;= 1)" flag="warning" id="UBL-SR-13-GST-SG">[UBL-SR-13-GST-SG]-Seller tax registration shall occur maximum once</assert>
			
			<assert test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)" flag="warning" id="UBL-SR-18-GST">[UBL-SR-18-GST]-Buyer GST identifier shall occur maximum once</assert>
			
		</rule>
		<rule context="cac:InvoiceLine">
			
			<assert test="(count(cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason) &lt;= 1)" flag="warning" id="UBL-SR-38-GST-SG">[UBL-SR-38-GST-SG]-Invoiced item GST exemption reason text shall occur maximum once</assert>
		</rule>
		
		
		
		<rule context="cac:TaxRepresentativeParty">
					<assert test="(count(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)" flag="warning" id="UBL-SR-23-GST-SG">[UBL-SR-23-GST-SG]-Seller tax representative GST identifier shall occur maximum once, if the Seller has a tax representative</assert>
		</rule>
		<rule context="cac:TaxSubtotal">
			<assert test="(count(cac:TaxCategory/cbc:TaxExemptionReason) &lt;= 1)" flag="warning" id="UBL-SR-32-SG">[UBL-SR-32-SG]-GST exemption reason text shall occur maximum once</assert>
		</rule>
	</pattern>
	<pattern id="Codesmodel">
		<!-- 2019-06-12/MF - Added newest ICD values manually -->
		
		<rule context="cac:TaxCategory/cbc:ID" flag="fatal">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C ZR ES33 ESN33 DS OS NG ',concat(' ',normalize-space(.),' ') ) ) )" id="BR-CL-17-GST-SG" flag="fatal">[BR-CL-17-GST-SG]-Invoice tax categories MUST be coded using valid Singapore code values</assert>
		</rule>
		<rule context="cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
			<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C ZR ES33 ESN33 DS OS NG ',concat(' ',normalize-space(.),' ') ) ) )" id="BR-CL-18-GST-SG" flag="fatal">[BR-CL-18-GST-SG]-Invoice tax categories MUST be coded using valid Singapore code values</assert>
		</rule>
		
		
	</pattern>
	</schema>
