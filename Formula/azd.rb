class Azd < Formula
  desc "Azure Developer CLI"
  homepage "https://github.com/azure/azure-dev"
  url "https://github.com/Azure/azure-dev.git",
    tag:      "azure-dev-cli_0.4.0-beta.1",
    revision: "2bf7a529914d86d8e9f5d7b6f95a4f20a2351e01"
  license "MIT"

  depends_on "go" => :build

  def install
    chdir "cli/azd" do
      ldflags = %W[
        -X "github.com/azure/azure-dev/cli/azd/internal.Version=#{version} (#{stable.specs[:revision]} homebrew)"
      ]

      # Only build for amd64 architecture (azd support for ARM is through Rosetta)
      with_env(GOARCH: "amd64") do
        system "go", "build", *std_go_args(ldflags: ldflags)
      end
    end
  end

  test do
    version_output = shell_output "#{bin}/azd version"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match "azd version", version_output
    assert_match "homebrew", version_output
  end
end
