defmodule Lux.Agents.YouTubeProducerAgentTest do
  use UnitCase, async: true

  alias Lux.Agents.YouTubeProducerAgent

  describe "YouTubeProducerAgent" do
    test "defines expected structure" do
      view = YouTubeProducerAgent.view()
      assert view.name == "YouTube Producer Agent"
      assert view.goal =~ "channel growth"
    end

    test "llm_config is correctly set" do
      view = YouTubeProducerAgent.view()
      assert view.llm_config.model == "gpt-4o-mini"
      assert view.llm_config.json_response == true
    end
  end
end
