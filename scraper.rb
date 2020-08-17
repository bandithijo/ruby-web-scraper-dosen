require 'httparty'
require 'nokogiri'
require 'byebug'
require 'date'

def scraper
  target_url = "http://baak.universitasmulia.ac.id/dosen/"
  unparsed_page = HTTParty.get(target_url)
  parsed_page = Nokogiri::HTML(unparsed_page)

  # daftar semua dosen
  dosens = Array.new
  dosen_listings = parsed_page.css('div.elementor-widget-wrap p')
  dosen_listings[1..-2].each do |dosen_list|
    nama_nidn_dosen = dosen_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
    dosen = {
      nama_dosen: nama_nidn_dosen&.gsub(/[^A-Za-z., ]/i, ''),
      nidn_dosen: nama_nidn_dosen&.gsub(/[^0-9]/i, '')
    }
    if dosen[:nama_dosen] != nil
      dosens << dosen
    end
  end

  # daftar dosen pria
  dosens_pria = Array.new
  dosen_pria_listings = parsed_page.css('div.elementor-widget-wrap')[9].css('p')
  dosen_pria_listings.each do |dosen_pria_list|
    nama_nidn_dosen_pria = dosen_pria_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
    dosen = {
      nama_dosen_pria: nama_nidn_dosen_pria&.gsub(/[^A-Za-z., ]/i, ''),
      nidn_dosen_pria: nama_nidn_dosen_pria&.gsub(/[^0-9]/i, '')
    }
    if dosen[:nama_dosen_pria] != nil
      dosens_pria << dosen
    end
  end

  # daftar dosen wanita
  dosens_wanita = Array.new
  dosen_wanita_listings = parsed_page.css('div.elementor-widget-wrap')[10].css('p')
  dosen_wanita_listings.each do |dosen_wanita_list|
    nama_nidn_dosen_wanita = dosen_wanita_list&.text&.gsub(/(^\w.*?:)|(NIDN :\s)/, "").strip
    dosen = {
      nama_dosen_wanita: nama_nidn_dosen_wanita&.gsub(/[^A-Za-z., ]/i, ''),
      nidn_dosen_wanita: nama_nidn_dosen_wanita&.gsub(/[^0-9]/i, '')
    }
    if dosen[:nama_dosen_wanita] != nil
      dosens_wanita << dosen
    end
  end
  # byebug

  File.delete("daftar_dosen.html") if File.exist?("daftar_dosen.html")
  File.open("daftar_dosen.html", "w") do |f|
    f.puts '<!DOCTYPE html>'
    f.puts '<html lang="en">'
    f.puts '<head>'
    f.puts '<meta charset="UTF-8">'
    f.puts "<title>Daftar Dosen Universitas Mulia (#{dosens.count} dosen)</title>"
    f.puts '</head>'
    f.puts '<body>'
    f.puts '<h1>Daftar Dosen<br>Universitas Mulia Balikpapan</h1>'
    f.puts "<p>Data terakhir diparsing: #{Date.today}</p>"

    f.puts '<div class="tab">'
    f.puts "<button class='tablinks' onclick=\"openTab(event, 'tab1')\">Semua Dosen</button>"
    f.puts "<button class='tablinks' onclick=\"openTab(event, 'tab2')\">Dosen Pria</button>"
    f.puts "<button class='tablinks' onclick=\"openTab(event, 'tab3')\">Dosen Wanita</button>"
    f.puts '</div>'

    f.puts '<div id="tab1" class="tabcontent active">'
    f.puts '<h2>Daftar Semua Dosen</h2>'
    f.puts "<p>Jumlah Seluruh Dosen: #{dosens.size} orang</p>"
    f.puts '<input type="text" id="inputDosens" onkeyup="cariDosens()" placeholder="Cari nama dosen..">'
    f.puts '<table id="tableDosens">'
    dosens.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{dosen[:nama_dosen]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'
    f.puts '</div>'

    f.puts '<div id="tab2" class="tabcontent">'
    f.puts '<h2>Daftar Dosen Pria</h2>'
    f.puts "<p>Jumlah Dosen Pria: #{dosens_pria.size} orang</p>"
    f.puts '<input type="text" id="inputDosensPria" onkeyup="cariDosensPria()" placeholder="Cari nama dosen pria..">'
    f.puts '<table id="tableDosensPria">'
    dosens_pria.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{dosen[:nama_dosen_pria]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen_pria]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'
    f.puts '</div>'

    f.puts '<div id="tab3" class="tabcontent">'
    f.puts '<h2>Daftar Dosen Wanita</h2>'
    f.puts "<p>Jumlah Dosen Wanita: #{dosens_wanita.size} orang</p>"
    f.puts '<input type="text" id="inputDosensWanita" onkeyup="cariDosensWanita()" placeholder="Cari nama dosen wanita..">'
    f.puts '<table id="tableDosensWanita">'
    dosens_wanita.each.with_index(1) do |dosen, index|
      f.puts '<tr>'
      f.puts "<td>#{dosen[:nama_dosen_wanita]}</td>"
      f.puts "<td>#{dosen[:nidn_dosen_wanita]}</td>"
      f.puts '</tr>'
    end
    f.puts '</table>'
    f.puts '</div>'

    f.puts '''
    <style>
    body {
      font-size: 11px;
    }
    table,th,td {
      border: 1px solid black;
      border-collapse: collapse;
    }
    td {
      padding: 3px;
    }
    .tab {
      overflow: hidden;
    }
    .tab button {
      background-color: inherit;
      float: left;
      border: none;
      outline: none;
      cursor: pointer;
      padding: 5px 5px 5px 0;
      transition: 0.3s;
      font-family: inherit;
      font-size: inherit;
      color: inherit;
      margin-right: 10px;
    }
    .tab button.active {
      text-decoration: underline;
    }
    .tabcontent {
      display: none;
    }
    #inputDosens, #inputDosensPria, #inputDosensWanita {
      width: 30%;
      padding: 0;
      border: 1px solid #ffffff;
      margin: 0 0 10px 0;
    }
    </style>
    '''

    f.puts '''
    <script>
    // Sumber: https://www.w3schools.com/howto/howto_js_tabs.asp
    function openTab(evt, tabNumber) {
      var i, tabcontent, tablinks;
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }
      tablinks = document.getElementsByClassName("tablinks");
      for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
      }
      document.getElementById(tabNumber).style.display = "block";
      evt.currentTarget.className += " active";
    }

    // Sumber: https://www.w3schools.com/howto/howto_js_filter_table.asp
    function cariDosens() {
      var input, filter, table, tr, td, i, txtValue;
      input = document.getElementById("inputDosens");
      filter = input.value.toUpperCase();
      table = document.getElementById("tableDosens");
      tr = table.getElementsByTagName("tr");
      for (i = 0; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td")[0];
        if (td) {
          txtValue = td.textContent || td.innerText;
          if (txtValue.toUpperCase().indexOf(filter) > -1) {
            tr[i].style.display = "";
          } else {
            tr[i].style.display = "none";
          }
        }
      }
    }

    function cariDosensPria() {
      var input, filter, table, tr, td, i, txtValue;
      input = document.getElementById("inputDosensPria");
      filter = input.value.toUpperCase();
      table = document.getElementById("tableDosensPria");
      tr = table.getElementsByTagName("tr");
      for (i = 0; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td")[0];
        if (td) {
          txtValue = td.textContent || td.innerText;
          if (txtValue.toUpperCase().indexOf(filter) > -1) {
            tr[i].style.display = "";
          } else {
            tr[i].style.display = "none";
          }
        }
      }
    }

    function cariDosensWanita() {
      var input, filter, table, tr, td, i, txtValue;
      input = document.getElementById("inputDosensWanita");
      filter = input.value.toUpperCase();
      table = document.getElementById("tableDosensWanita");
      tr = table.getElementsByTagName("tr");
      for (i = 0; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td")[0];
        if (td) {
          txtValue = td.textContent || td.innerText;
          if (txtValue.toUpperCase().indexOf(filter) > -1) {
            tr[i].style.display = "";
          } else {
            tr[i].style.display = "none";
          }
        }
      }
    }
    </script>
    '''

    f.puts '</body>'
    f.puts '</html>'
  end

  puts "TOTAL SELURUH DOSEN : #{dosens.count} orang"
  puts "TOTAL DOSEN PRIA    : #{dosens_pria.count} orang"
  puts "TOTAL DOSEN WANITA  : #{dosens_wanita.count} orang"
end

scraper
puts "index.html created!" if %x(cp -f daftar_dosen.html index.html)
