import React from 'react';
import { NeoInput, NeoButton, NeoCard } from '../components/UI';
import { Search } from 'lucide-react';

const ExploreCard = ({ title, tag, image, user }: { title: string, tag: string, image: string, user: string }) => (
    <NeoCard noPadding className="h-full flex flex-col hover:-translate-y-1 hover:shadow-hard-lg transition-all cursor-pointer">
        <div className="h-40 border-b-2 border-black overflow-hidden relative">
            <img src={image} className="w-full h-full object-cover" alt={title} />
            <div className="absolute top-2 right-2 bg-neo-primary border-2 border-black px-2 py-0.5 text-xs font-bold shadow-hard-sm">
                #{tag}
            </div>
        </div>
        <div className="p-4 flex flex-col flex-1">
            <h3 className="font-bold text-lg leading-tight mb-2">{title}</h3>
            <p className="font-mono text-xs text-gray-500 mt-auto">by {user}</p>
        </div>
    </NeoCard>
)

export const Explore: React.FC = () => {
  return (
    <div className="p-4 md:p-8 max-w-6xl mx-auto">
      <header className="mb-8">
        <h1 className="text-5xl md:text-6xl font-black tracking-tighter mb-6">Khám phá</h1>
        
        <div className="relative mb-6">
            <input 
                className="w-full h-16 border-4 border-black bg-white px-6 text-xl font-bold placeholder:text-gray-400 focus:outline-none focus:shadow-hard transition-shadow"
                placeholder="Neo-Brutalism"
            />
            <button className="absolute right-3 top-3 bottom-3 aspect-square bg-neo-bg border-2 border-black flex items-center justify-center hover:bg-neo-primary transition-colors">
                <Search size={28} />
            </button>
        </div>

        <div className="flex gap-3 overflow-x-auto pb-4">
            <NeoButton variant="primary" size="sm">Tất cả</NeoButton>
            <NeoButton variant="secondary" size="sm">Bài viết</NeoButton>
            <NeoButton variant="secondary" size="sm">Người dùng</NeoButton>
            <NeoButton variant="secondary" size="sm">Ảnh</NeoButton>
        </div>
      </header>

      <div className="mb-4">
        <h2 className="text-2xl font-bold">Kết quả cho '<span className="text-neo-primary">Neo-Brutalism</span>'</h2>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <ExploreCard 
            title="The Rise of Neo-Brutalism in Modern Web Design" 
            tag="design" 
            user="@design_guru"
            image="https://picsum.photos/seed/neo1/400/300"
        />
        <ExploreCard 
            title="UI Kits for Brutalist-Inspired Projects" 
            tag="resources" 
            user="@ui_kit_master"
            image="https://picsum.photos/seed/neo2/400/300"
        />
         <NeoCard noPadding className="h-full bg-neo-pastelBlue flex flex-col items-center justify-center text-center p-6 border-2 border-black shadow-hard hover:-translate-y-1 transition-transform">
             <div className="w-20 h-20 bg-gray-300 rounded-full border-2 border-black mb-3 overflow-hidden">
                 <img src="https://picsum.photos/seed/dev/100" className="w-full h-full object-cover" />
             </div>
             <h3 className="font-bold text-lg">@brutal_dev</h3>
             <p className="font-mono text-xs text-gray-700 mb-4">Designer & Developer crafting raw digital experiences.</p>
             <NeoButton size="sm" fullWidth className="bg-white">Follow</NeoButton>
         </NeoCard>
        <ExploreCard 
            title="Color Palettes in Neo-Brutalism" 
            tag="colors" 
            user="@palette_pro"
            image="https://picsum.photos/seed/neo3/400/300"
        />
      </div>
    </div>
  );
};
