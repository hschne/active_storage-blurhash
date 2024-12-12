class ActiveStorage::Blurhash::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_javascript_deps
    if importmap_present?
      say "Pinning blurhash"
      run "bin/importmap pin blurhash"
    else
      say "Installing blurhash"
      run "yarn add blurhash"
    end
  end

  def copy_application_javascript
    directory "javascript", "app/javascript/blurhash"
  end

  def pin_blurhash_javascript
    if importmap_present?
      append_to_file "config/importmap.rb", 'pin "active_storage_blurhash", to: "blurhash/index.js"' + "\n"
    end
  end

  def append_to_main_javascript_entrypoint
    if importmap_present?
      append_to_file "app/javascript/application.js", "import \"active_storage_blurhash\";\n"
    else
      append_to_file "app/javascript/application.js", "import \"./blurhash\";\n"
    end
  end

  private

  def importmap_present?
    File.exist? Rails.root.join("config", "importmap.rb")
  end
end
