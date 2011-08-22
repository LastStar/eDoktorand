require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Publication do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:publicationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <publicationsList>
    <publication>
      <publication_id>22321</publication_id>
      <name>Ultrastructure of the microsporidium, Duboscqia legeri, the type species of the genus Duboscqia Perez, 1908</name>
      <name_english>Ultrastructure of the microsporidium, Duboscqia legeri, the type species of the genus Duboscqia Perez, 1908</name_english>
      <publication_year>2010</publication_year>
      <authors>RNDr. Jaroslav Weiser, DrSc., P Belton (externí), Zdeněk Žižka (externí), doc. Ing. Jaroslav Holuša, Ph.D.</authors>
      <quotations>WEISER, J. – BELTON, P. – ŽIŽKA, Z. – HOLUŠA, J. Ultrastructure of the microsporidium, Duboscqia legeri, the type species of the genus Duboscqia Perez, 1908. <i>Acta Protozoologica, </i> 2010, roč. 49, č. 2, s. 125 - 131. ISSN: 0065-1583.</quotations>
      <publication_type_id>1</publication_type_id>
      <publication_type>Článek v odborném periodiku</publication_type>
      <cep>Mikrobiologie, virologie</cep>
      <publication_authors>
        <authorship>
        <publication_person_id>45886</publication_person_id>
        <publication_id>22321</publication_id>
        <uic>102688</uic>
        <author_order>4</author_order>
        </authorship>
        <authorship>
        <publication_person_id>45887</publication_person_id>
        <publication_id>22321</publication_id>
        <uic>506808</uic>
        <author_order>3</author_order>
        </authorship>
        <authorship>
        <publication_person_id>45890</publication_person_id>
        <publication_id>22321</publication_id>
        <uic>510754</uic>
        <author_order>2</author_order>
        </authorship>
        <authorship>
        <publication_person_id>97362</publication_person_id>
        <publication_id>22321</publication_id>
        <uic>50005</uic>
        <author_order>1</author_order>
        </authorship>
      </publication_authors>
      <publication_grants>
        <grant_publication>
        <publication_grant_id>101625</publication_grant_id>
        <publication_id>22321</publication_id>
        <grant_id>975</grant_id>
        </grant_publication>
      </publication_grants>
    </publication>
  </publicationsList>
</soap:publicationResponse>
BODY
    end
    it "it returns array of grants hashes" do
      CentralRegister::Publication.find(50005).should == [
        {
        :name => 'Ultrastructure of the microsporidium, Duboscqia legeri, the type species of the genus Duboscqia Perez, 1908',
        :name_english => 'Ultrastructure of the microsporidium, Duboscqia legeri, the type species of the genus Duboscqia Perez, 1908',
        :publication_year => '2010',
        :authors => 'RNDr. Jaroslav Weiser, DrSc., P Belton (externí), Zdeněk Žižka (externí), doc. Ing. Jaroslav Holuša, Ph.D.',
        :quotations => 'WEISER, J. – BELTON, P. – ŽIŽKA, Z. – HOLUŠA, J. Ultrastructure of the microsporidium, Duboscqia legeri, the type species of the genus Duboscqia Perez, 1908.',
        :publication_type_id => '1',
        :publication_type => 'Článek v odborném periodiku',
        :cep => 'Mikrobiologie, virologie',
        }
      ]
    end
  end
end





