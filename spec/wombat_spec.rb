require 'spec_helper'

describe Wombat do
  it 'should provide syntactic sugar method Wombat.crawl' do
    Wombat.should respond_to(:crawl)
  end

  it 'should provide syntactic sugar method Wombat.scrape' do
    Wombat.should respond_to(:scrape)
  end

  it 'should redirect .scrape to .crawl' do
    fake_class = double :fake
    fake_class.stub :include
    fake_class.should_receive(:new).and_return(double(crawl: nil))
    Class.stub :new => fake_class
    Wombat.scrape
  end

  it 'should provide configuration method with block' do
    Wombat.configure do |config|
      config.set_proxy "10.0.0.1", 8080
      config.set_user_agent "Wombat"
      config.set_user_agent_alias 'Mac Safari'
      config.set_cookies expired: Time.now
    end
    Wombat.proxy_args.should == ["10.0.0.1", 8080]
    Wombat.user_agent.should == 'Wombat'
    Wombat.user_agent_alias.should == 'Mac Safari'
    Wombat.cookies.keys.should == [:expired]
  end

  it 'should accept regular properties (non-selectors)' do
    VCR.use_cassette('broken_selector') do
      lambda {
        Wombat.crawl do
          base_url "http://www.github.com"
          path "/"

          source :obaoba
          description 'Oba Oba'
          website 'http://obaoba.com.br'
        end
      }.should_not raise_error
    end
  end
end
