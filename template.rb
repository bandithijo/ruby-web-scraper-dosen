# frozen_string_literal: true

class Template
  require 'date'

  attr_accessor :dosens, :dosens_pria, :dosens_wanita

  def initialize(dosens, dosens_pria, dosens_wanita)
    @dosens        = dosens
    @dosens_pria   = dosens_pria
    @dosens_wanita = dosens_wanita
  end

  def create_html
    File.delete('daftar_dosen.html') if File.exist?('daftar_dosen.html')
    File.open('daftar_dosen.html', 'w') do |f|
      f.puts """
      <!DOCTYPE html>
      <html lang='en'>
      <head>
      <meta charset='UTF-8'>
      <meta name='viewport' content='width=device-width, initial-scale=1'>
      <title>Dosen Universitas Mulia Balikpapan(#{dosens.count} dosen)</title>
      </head>
      <body>
      <h1 style='margin-bottom:0;'>Dosen 👨‍🏫 👩‍🏫<br>Universitas Mulia 🎓<br>Balikpapan</h1>

      <p style='margin-top:10px;'>Made with ❤ by <a href='https://bandithijo.github.io'>Rizqi Nur Assyaufi</a> - 2020/07/12<br>
      Powered by <a href='http://ruby-lang.org'>💎 Ruby</a> |
      Source Code on <a href='https://github.com/bandithijo/ruby-web-scraper-dosen'>📦 GitHub</a></p>

      <p>Data terakhir diparsing: <b>#{Date.today}</b></p>
      """

      f.puts '<div class="tab">'
      ['Semua Dosen', 'Dosen Pria', 'Dosen Wanita'].each.with_index(1) do |dosen, index|
        f.puts "<button class='tablinks' onclick=\"openTab(event, 'tab#{index}')\">#{dosen}</button>"
      end
      f.puts '</div>'

      f.puts '<div id="tab1" class="tabcontent active">'
      f.puts '<h2>📑 Daftar Semua Dosen</h2>'
      f.puts "<p style='margin-top:-12px;'>Jumlah Seluruh Dosen: #{dosens.size} orang</p>"
      f.puts '<input type="text" id="inputDosens" onkeyup="cariDosens()" placeholder="🔍 Cari nama dosen...">'
      f.puts '<table id="tableDosens">'
      dosens.each do |dosen|
        f.puts '<tr>'
        f.puts "<td>#{dosen[:nama_dosen]}</td>"
        f.puts "<td>#{dosen[:nidn_dosen]}</td>"
        f.puts '</tr>'
      end
      f.puts '</table>'
      f.puts '</div>'

      f.puts '<div id="tab2" class="tabcontent">'
      f.puts '<h2>📑 Daftar Dosen Pria</h2>'
      f.puts "<p style='margin-top:-12px;'>Jumlah Dosen Pria: #{dosens_pria.size} orang</p>"
      f.puts '<input type="text" id="inputDosensPria" onkeyup="cariDosens()" placeholder="🔍 Cari nama dosen pria...">'
      f.puts '<table id="tableDosensPria">'
      dosens_pria.each do |dosen|
        f.puts '<tr>'
        f.puts "<td>#{dosen[:nama_dosen]}</td>"
        f.puts "<td>#{dosen[:nidn_dosen]}</td>"
        f.puts '</tr>'
      end
      f.puts '</table>'
      f.puts '</div>'

      f.puts '<div id="tab3" class="tabcontent">'
      f.puts '<h2>📑 Daftar Dosen Wanita</h2>'
      f.puts "<p style='margin-top:-12px;'>Jumlah Dosen Wanita: #{dosens_wanita.size} orang</p>"
      f.puts '<input type="text" id="inputDosensWanita" onkeyup="cariDosens()" placeholder="🔍 Cari nama dosen wanita...">'
      f.puts '<table id="tableDosensWanita">'
      dosens_wanita.each do |dosen|
        f.puts '<tr>'
        f.puts "<td>#{dosen[:nama_dosen]}</td>"
        f.puts "<td>#{dosen[:nidn_dosen]}</td>"
        f.puts '</tr>'
      end
      f.puts '</table>'
      f.puts '</div>'

      f.puts '''
      <div class="petunjuk">
      <b>🎯 PETUNJUK</b>
      <p style="margin-top:0;">Klik salah satu dari tiga daftar kategori dosen di atas.</p>
      </div>

      <br>

      <div class="footnote">
      <b>📢 INFO</b>
      <p style="margin-top:0;">Apabila terdapat kesalahan dalam penulisan / gelar milik dosen yang tidak lengkap / nama dosen bersangkutan tidak terdaftar, harap melaporkan kesalahan dan kekeliruan tersebut ke bagian BAAK untuk kami lakukan perubahan.</p>
      </div>

      <div class="footnote">
      <b>📜 TENTANG</b>
      <p style="margin-top:0;">Web aplikasi sederhana ini dibuat untuk tujuan belajar. Dibangun menggunakan teknik <i>web scraping</i> dengan data yang langsung diambil dari website target belajar. Program ditulis menggunakan bahasa pemrograman Ruby.</p>
      </div>
      '''

      f.puts '''
      <style>
      :root {
        --fg-color: #000;
        --bg-color: #fff;
        --a-color: #0000ff;
      }
      ::placeholder {
        color: var(--fg-color);
        opacity: 0.5;
      }
      body {
        background-color: var(--bg-color);
        color: var(--fg-color);
        font-family: Helvetica, Arial;
        font-size: 16px;
      }
      a, a:visited {
        color: var(--a-color);
        text-decoration: none;
      }
      table,th,td {
        border: 1px solid var(--fg-color);
        border-collapse: collapse;
      }
      td {
        padding: 3px;
      }
      td:nth-child(2) {
        font-family: monospace;
        text-align: center;
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
        padding: 10px 5px 5px 5px;
        transition: 0.3s;
        font-family: inherit;
        font-size: inherit;
        color: inherit;
        margin-right: 10px;
        border: 1px solid var(--fg-color);
        border-radius: 3px;
      }
      .tab button.active {
        background-color: var(--fg-color);
        color: var(--bg-color);
      }
      .tabcontent {
        display: none;
      }
      input:focus, textarea:focus, select:focus{
        background-color: var(--bg-color);
        color: var(--fg-color);
        outline: none;
      }
      #inputDosens, #inputDosensPria, #inputDosensWanita {
        background-color: var(--bg-color);
        width: 30%;
        padding: 1px;
        border: 1px solid var(--bg-color);
        margin: 0 0 12px 0;
        font-family: inherit;
        font-size: 16px;
      }
      .petunjuk {
        margin-top: 20px;
        text-align: left;
      }
      .footnote {
        margin-top: 15px;
        text-align: left;
        width: 33%;
        word-wrap: break-word;
      }
      @media screen and (max-width: 768px) {
        .footnote {
          width: 100%;
        }
      }
      @media screen and (width: 414px) {
        table, #inputDosens, #inputDosensPria, #inputDosensWanita {
          width: 100%;
        }
      }
      @media screen and (width: 375px) {
        .tab button {
          float: none;
          font-size: 15px !important;
          padding: 10px 5px 5px 5px;
          font-size: inherit;
          margin-right: none !important;
        }
        table, #inputDosens, #inputDosensPria, #inputDosensWanita {
          width: 100%;
        }
      }
      @media screen and (width: 360px) {
        .tab button {
          float: none;
          font-size: 15px !important;
          padding: 10px 5px 5px 5px;
          font-size: inherit;
          margin-right: none !important;
        }
        table, #inputDosens, #inputDosensPria, #inputDosensWanita {
          width: 100%;
        }
      }
      @media screen and (width: 320px) {
        .tab button {
          font-size: 13px !important;
        }
        table, #inputDosens, #inputDosensPria, #inputDosensWanita {
          width: 100%;
        }
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
        var input, filter, table, tr,
            inputPria, filterPria, tablePria, trPria,
            inputWanita, filterWanita, tableWanita, trWanita,
            td, i, txtValue;
      '''

      ['', 'Pria', 'Wanita'].each do |dosen|
        f.puts """
        input#{dosen} = document.getElementById('inputDosens#{dosen}');
        filter#{dosen} = input#{dosen}.value.toUpperCase();
        table#{dosen} = document.getElementById('tableDosens#{dosen}');
        tr#{dosen} = table#{dosen}.getElementsByTagName('tr');
        for (i = 0; i < tr#{dosen}.length; i++) {
          td = tr#{dosen}[i].getElementsByTagName('td')[0];
          if (td) {
            txtValue = td.textContent || td.innerText;
            if (txtValue.toUpperCase().indexOf(filter#{dosen}) > -1) {
              tr#{dosen}[i].style.display = '';
            } else {
              tr#{dosen}[i].style.display = 'none';
            }
          }
        }
        """
      end

      f.puts '''
      }
      </script>
      '''

      f.puts '</body>'
      f.puts '</html>'
    end
  end
end
