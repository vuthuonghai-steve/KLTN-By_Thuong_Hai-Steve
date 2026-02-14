import React from 'react';
import { NeoCard, NeoAvatar, NeoButton, NeoBadge } from '../components/UI';
import { Heart, MessageSquare } from 'lucide-react';

const StatCard = ({ count, label }: { count: string, label: string }) => (
  <NeoCard className="flex-1 min-w-[120px]" noPadding>
      <div className="p-4">
        <h4 className="text-3xl font-black tracking-tighter">{count}</h4>
        <p className="font-mono text-sm text-gray-600">{label}</p>
      </div>
  </NeoCard>
);

export const Profile: React.FC = () => {
  return (
    <div className="max-w-5xl mx-auto p-4 md:p-8">
      
      {/* Header Card */}
      <NeoCard className="mb-8 relative overflow-hidden">
        {/* Abstract Background */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-gradient-to-br from-neo-pastelBlue to-neo-pastelGreen rounded-full blur-3xl opacity-50 -translate-y-1/2 translate-x-1/2 pointer-events-none"></div>

        <div className="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
          <div className="flex flex-col md:flex-row items-center md:items-start gap-6">
            <div className="w-32 h-32 rounded bg-gradient-to-tr from-teal-400 to-neo-bg border-2 border-black shadow-hard shrink-0"></div>
            <div>
              <h1 className="text-3xl md:text-4xl font-black mb-1">Olivia Chen</h1>
              <p className="font-mono text-neo-primary font-bold mb-2">@oliviachen_dev</p>
              <p className="font-mono text-sm max-w-md mb-2">Frontend dev & UI enthusiast. // Building cool stuff.</p>
              <div className="flex gap-2">
                 <NeoBadge color="bg-neo-pastelGreen">OPEN TO WORK</NeoBadge>
                 <NeoBadge color="bg-neo-pastelBlue">PRO</NeoBadge>
              </div>
            </div>
          </div>
          
          <div className="flex gap-3 w-full md:w-auto">
            <NeoButton variant="secondary" className="flex-1 md:flex-none">Follow</NeoButton>
            <NeoButton variant="primary" className="flex-1 md:flex-none">Message</NeoButton>
          </div>
        </div>
      </NeoCard>

      {/* Stats */}
      <div className="flex flex-wrap gap-4 mb-10">
        <StatCard count="128" label="Posts" />
        <StatCard count="1.2K" label="Followers" />
        <StatCard count="543" label="Following" />
      </div>

      <h2 className="text-2xl font-bold mb-6 font-mono border-b-2 border-black pb-2 inline-block">// Posts</h2>

      {/* Content Feed */}
      <div className="grid gap-8">
        {/* Post 1 */}
        <NeoCard noPadding>
            <div className="flex flex-col md:flex-row">
                <div className="md:w-2/5 border-b-2 md:border-b-0 md:border-r-2 border-black bg-[#F8F3E6] p-4 flex items-center justify-center">
                    <img src="https://picsum.photos/seed/design/400/300" alt="Design" className="w-full h-auto border-2 border-black shadow-hard-sm" />
                </div>
                <div className="md:w-3/5 p-6 flex flex-col justify-between">
                    <div>
                        <span className="font-mono text-xs text-gray-500 mb-2 block">1 hour ago</span>
                        <h3 className="text-xl font-bold mb-2">My Latest Design Project</h3>
                        <p className="font-mono text-sm leading-relaxed mb-4 text-gray-700">
                            Exploring the neo-brutalism style for a new social media concept. Raw, functional, and honest design.
                            {` {...more thoughts}`}
                        </p>
                    </div>
                    <div className="flex gap-4 pt-4 border-t-2 border-black border-dashed">
                        <div className="flex items-center gap-2 font-mono text-sm font-bold text-orange-600">
                            <Heart size={16} /> 256
                        </div>
                        <div className="flex items-center gap-2 font-mono text-sm font-bold">
                            <MessageSquare size={16} /> 32
                        </div>
                    </div>
                </div>
            </div>
        </NeoCard>

        {/* Post 2 */}
        <NeoCard noPadding>
            <div className="p-6">
                <span className="font-mono text-xs text-gray-500 mb-2 block">Yesterday</span>
                <h3 className="text-xl font-bold mb-3">On Typography and Code</h3>
                <p className="font-mono text-sm leading-relaxed mb-4 border-l-4 border-neo-primary pl-4 py-1 bg-orange-50">
                    There's a certain beauty in monospace fonts. They bring a sense of order and structure, much like well-written code. Every character occupies the same space, creating a perfect grid of text.
                </p>
                <div className="flex gap-4 mt-4">
                    <div className="flex items-center gap-2 font-mono text-sm font-bold text-orange-600">
                         <Heart size={16} fill="currentColor" /> 1.1K
                    </div>
                    <div className="flex items-center gap-2 font-mono text-sm font-bold">
                        <MessageSquare size={16} /> 109
                    </div>
                </div>
            </div>
        </NeoCard>
      </div>

    </div>
  );
};
