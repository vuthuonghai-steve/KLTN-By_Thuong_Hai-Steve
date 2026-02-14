import React from 'react';
import { NeoCard, NeoButton, NeoAvatar, NeoBadge } from '../components/UI';
import { Heart, MessageSquare, Share2, MoreHorizontal } from 'lucide-react';

const mockPosts = [
  {
    id: '1',
    user: {
      name: 'Sara Cruz',
      handle: '@sara_codes',
      avatar: 'https://picsum.photos/seed/sara/200'
    },
    time: '2 hours ago',
    content: "Just deployed a new feature with a pure Neo-Brutalist UI. What do you all think? Loving the hard shadows and the vibrant orange accent color. #webdev #uidesign",
    image: 'https://picsum.photos/seed/ui/800/450',
    likes: '2.5k',
    comments: 152,
    shares: 99
  },
  {
    id: '2',
    user: {
      name: 'Peter Miller',
      handle: '@pixel_pete',
      avatar: 'https://picsum.photos/seed/peter/200'
    },
    time: '5 hours ago',
    content: "Exploring the city's architecture today. Found some amazing brutalist buildings that perfectly match the vibe I'm going for in my projects.",
    image: 'https://picsum.photos/seed/arch/800/450',
    likes: '1.2k',
    comments: 89,
    shares: 45
  }
];

const TrendingWidget = () => (
  <NeoCard className="sticky top-6">
    <div className="font-mono text-sm text-gray-500 mb-2">// trending_topics</div>
    <h3 className="text-xl font-bold uppercase border-b-2 border-black pb-2 mb-4">{`{ TRENDING }`}</h3>
    <ul className="space-y-3">
      {['#NeoBrutalism *', '#WebDesign_Trends', '#UIUX', '#HardShadows_FTW', '#FunctionalDesign'].map((tag, i) => (
        <li key={i} className="font-mono text-sm hover:text-neo-primary hover:underline cursor-pointer transition-colors">
          {tag}
        </li>
      ))}
    </ul>
  </NeoCard>
);

const UserWidget = () => (
  <NeoCard className="mb-8 bg-neo-pastelYellow">
    <div className="font-mono text-sm text-gray-500 mb-2">// profile_widget</div>
    <div className="flex flex-col items-center text-center">
      <NeoAvatar src="https://picsum.photos/seed/me/200" alt="Me" size="lg" className="mb-4 shadow-hard" />
      <h3 className="text-xl font-bold">Alex Doe</h3>
      <p className="font-mono text-sm text-gray-600 mb-4">@alex_brutalist</p>
      <NeoButton fullWidth size="sm">New Post</NeoButton>
    </div>
  </NeoCard>
);

export const Feed: React.FC = () => {
  return (
    <div className="p-4 md:p-8 max-w-7xl mx-auto">
      <header className="mb-8 flex justify-between items-center border-b-2 border-black pb-4">
        <div>
           <h1 className="text-4xl md:text-5xl font-black uppercase">LATEST</h1>
           <div className="flex gap-2 mt-2">
             <span className="w-3 h-3 bg-green-500 border border-black rounded-full"></span>
             <span className="font-mono text-xs text-gray-600">SYSTEM_ONLINE</span>
           </div>
        </div>
        <div className="hidden md:block">
            <NeoBadge color="bg-orange-400">UPDATED_DAILY</NeoBadge>
        </div>
      </header>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {/* Main Feed */}
        <div className="lg:col-span-8 space-y-8">
          {mockPosts.map(post => (
            <NeoCard key={post.id} noPadding className="overflow-hidden">
              <div className="p-4 flex items-center justify-between border-b-2 border-black bg-white">
                <div className="flex items-center gap-3">
                  <NeoAvatar src={post.user.avatar} alt={post.user.name} />
                  <div>
                    <h4 className="font-bold text-lg leading-none">{post.user.name}</h4>
                    <p className="font-mono text-xs text-gray-500 mt-1">{post.user.handle} // {post.time}</p>
                  </div>
                </div>
                <button className="p-2 hover:bg-gray-100 border-2 border-transparent hover:border-black transition-all">
                  <MoreHorizontal size={20} />
                </button>
              </div>
              
              <div className="p-4 bg-white">
                <p className="mb-4 text-base leading-relaxed whitespace-pre-line">
                    {post.content.split(' ').map((word, i) => 
                        word.startsWith('#') ? <span key={i} className="text-neo-primary font-bold font-mono">{word} </span> : word + ' '
                    )}
                </p>
                {post.image && (
                  <div className="border-2 border-black shadow-hard-sm">
                    <img src={post.image} alt="Post attachment" className="w-full h-auto object-cover max-h-[500px]" />
                  </div>
                )}
              </div>

              <div className="p-3 bg-gray-50 border-t-2 border-black flex gap-4">
                <NeoButton variant="ghost" size="sm" className="bg-white">
                  <Heart size={16} /> {post.likes}
                </NeoButton>
                <NeoButton variant="ghost" size="sm" className="bg-white">
                  <MessageSquare size={16} /> {post.comments}
                </NeoButton>
                <NeoButton variant="ghost" size="sm" className="bg-white">
                  <Share2 size={16} /> {post.shares}
                </NeoButton>
              </div>
            </NeoCard>
          ))}
          
          <div className="py-8 text-center">
             <p className="font-mono text-gray-500 animate-pulse">Loading more content...</p>
          </div>
        </div>

        {/* Sidebar Widgets */}
        <div className="hidden lg:block lg:col-span-4 space-y-8">
           <UserWidget />
           <TrendingWidget />
        </div>
      </div>
    </div>
  );
};
