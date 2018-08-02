# coding: utf-8
require 'spec_helper'

describe 'following pages referred by relative links' do
  it 'should follow relative links' do
    VCR.use_cassette('follow_relative_links') do
      crawler = Class.new
      crawler.send(:include, Wombat::Crawler)

      crawler.base_url "http://liteproblog.ru/"
      crawler.path 'vocabulary'

      crawler.vocabulary 'css=.postcontent ul li a', :follow do
        entry do
          word 'css=.post p strong', :text
          description 'css=.post p'
        end
      end

      crawler_instance = crawler.new

      results = crawler_instance.crawl

      # There are many entries. It's enough to check first three ones
      results["vocabulary"][0..2].should == [
{"entry"=>{"word"=>"Dmoz", "description"=>"Dmoz - второй по популярности каталог сайтов после Яндекс-Каталога. Адрес каталога Dmoz - .\r\n\r\nЗаметка: Как вы думаете, мебель из Китая дорого стоит? Правильно, она недорогая.  поставляет не только мебель, но и китайскую сантехнику, люстры, светильники и многое другое. Если вы хотите здорово съэкономить, то не пропустите такую возможность."}},
{"entry"=>{"word"=>"PR", "description"=>"PR - PageRank - показатель Google для конкретной страницы сайта. Зависит от количества ссылок на страницу и от качества этих ссылок. Учитываются и ссылки с внутренних страниц сайта. PR влияет на выдачу в поисковой системе Google. Повысить PR сайту можно внутренней перелинковкой. PR бывает тулбарный и внутренний. Апдейт PR происходит, как правило, несколько раз в год. Сейчас у этого блога PR=2, а у сайта  PR равен 3."}},
{"entry"=>{"word"=>"Sape (сапа)", "description"=>"Sape (сапа) - это самая популярная в России биржа ссылок. Адрес: www.sape.ru. Веб-мастер может продать ссылки со своего сайта, а оптимизатор купить ссылки. Продажа ссылок осуществляется с ежемесячной оплатой. Цена на ссылки устанавливается веб-мастером для своего сайта. Для продажи ссылок на сайте размещается специальный код системы и в дальнейшем вся продажа происходит автоматически через веб-интерфейс Sape.\r\n\r\nЗаметка: Интересует монтаж и эксплуатация противопожарных металлических ДПМ или ? Читайте технологическую документацию и нормативные документы."}}
      ]
    end
  end

end
