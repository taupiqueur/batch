require "./spec_helper"

describe "batch" do
  context "without items" do
    run_binary(args: ["-"], input: "", success: false, error: "ERROR: Nothing to do.\n")
  end

  context "with items from argv" do
    run_binary(args: ["Star Platinum", "Magician's Red", "Hermit Purple", "Hierophant Green", "Silver Chariot", "The Fool"], file: "star-platinum\n\nhermit-purple\n\nsilver-chariot\n\n", output: "Star Platinum star-platinum\nHermit Purple hermit-purple\nSilver Chariot silver-chariot\nMagician's Red\nHierophant Green\nThe Fool\n")
  end

  context "with multi-line items" do
    run_binary(args: ["a\nb"], success: false, error: %(ERROR: Cannot work with multi-line items: ["a\\nb"].\n))
  end

  context "with items from stdin" do
    run_binary(args: ["-"], input: "Star Platinum\nMagician's Red\nHermit Purple\nHierophant Green\nSilver Chariot\nThe Fool\n", file: "star-platinum\n\nhermit-purple\n\nsilver-chariot\n\n", output: "Star Platinum star-platinum\nHermit Purple hermit-purple\nSilver Chariot silver-chariot\nMagician's Red\nHierophant Green\nThe Fool\n")
  end

  context "with filters" do
    run_binary(args: ["--filter=tr [:upper:] [:lower:]", "--filter=tr -s [:blank:] -", "--filter=tr -d \\'"], input: "Star Platinum\nMagician's Red\nHermit Purple\nHierophant Green\nSilver Chariot\nThe Fool\n", output: "Star Platinum star-platinum\nMagician's Red magicians-red\nHermit Purple hermit-purple\nHierophant Green hierophant-green\nSilver Chariot silver-chariot\nThe Fool the-fool\n")
  end

  context "with panicked filters" do
    run_binary(args: ["--filter=cat", "--filter=nil", "--filter=cat"], input: "a\n", success: false, error: "ERROR: Running external filter 'nil': Error executing process: 'nil': No such file or directory.\n")
  end

  context "with invalid file" do
    run_binary(args: ["a", "b"], file: "c\n", success: false, error: "ERROR: Cannot operate translation. Number of lines differs.\n")
  end

  context "with non-zero exit code" do
    run_binary(edit: true, args: ["--editor=false"], input: "a\n", success: false, error: "ERROR: false exited with: 1.\n")
  end

  context "with invalid editor" do
    run_binary(edit: true, args: ["--editor=nil"], input: "a\n", success: false, error: "ERROR: Running command 'nil': Error executing process: 'nil': No such file or directory.\n")
  end

  describe "--pick-command" do
    run_binary(args: ["--pick-command=echo pick", "--no-map", "--no-drop"], input: "a\nb\n", file: "a\n\n", output: "pick a\n")
  end

  describe "--map-command" do
    run_binary(args: ["--no-pick", "--map-command=echo map", "--no-drop"], input: "a\nb\n", file: "A\n\n", output: "map a A\n")
  end

  describe "--drop-command" do
    run_binary(args: ["--no-pick", "--no-map", "--drop-command=echo drop"], input: "a\nb\n", file: "\nb\n", output: "drop a\n")
  end

  describe "--pick-shell-script" do
    run_binary(args: [%(--pick-shell-script=echo pick "[$1]"), "--no-map", "--no-drop"], input: "a\nb\n", file: "a\n\n", output: "pick [a]\n")
  end

  describe "--map-shell-script" do
    run_binary(args: ["--no-pick", %(--map-shell-script=echo map "[$1]" "[$2]"), "--no-drop"], input: "a\nb\n", file: "A\n\n", output: "map [a] [A]\n")
  end

  describe "--drop-shell-script" do
    run_binary(args: ["--no-pick", "--no-map", %(--drop-shell-script=echo drop "[$1]")], input: "a\nb\n", file: "\nb\n", output: "drop [a]\n")
  end
end
