# frozen_string_literal: true

Capybara::SpecHelper.spec "#to_capybara_node" do
  before do
    @session.visit('/with_html')
  end

  class NodeWrapper
    def initialize(element); @element = element end
    def to_capybara_node(); @element end
  end

  it "should support have_xxx expectations" do
    para = NodeWrapper.new(@session.find(:css, '#first'))
    expect(para).to have_link("ullamco")
  end

  it "should support within" do
    para = NodeWrapper.new(@session.find(:css, '#first'))
    expect(@session).to have_css('#second')
    @session.within(para) do
      expect(@session).to have_link('ullamco')
      expect(@session).not_to have_css('#second')
    end
  end

  it "should generate correct errors" do
    para = NodeWrapper.new(@session.find(:css, '#first'))
    expect do
      expect(para).to have_text("Header Class Test One")
    end.to raise_error(/^expected to find text "Header Class Test One" in "Lore/)
    expect do
      expect(para).to have_css('#second')
    end.to raise_error(/^expected to find visible css "#second" within #<Capybara::Node::Element/)
  end
end
