module SinatraStore
	module Routes
		def self.store_root
			"/"
		end
		def self.customer_root
			"/customer"
		end
		def album_url(album)
			"#{SinatraStore::Routes.store_root}#{album.artist.slug}/#{album.slug}"
		end
	end
end
