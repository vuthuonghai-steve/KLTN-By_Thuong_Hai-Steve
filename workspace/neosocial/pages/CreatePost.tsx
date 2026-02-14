import React from 'react';
import { NeoCard, NeoButton } from '../components/UI';
import { Plus } from 'lucide-react';

export const CreatePost: React.FC = () => {
  return (
    <div className="p-4 md:p-8 max-w-4xl mx-auto">
       <NeoCard className="min-h-[600px] flex flex-col relative">
           <div className="mb-8">
               <h1 className="text-4xl font-black italic mb-2">// TẠO BÀI VIẾT MỚI</h1>
               <p className="font-mono text-gray-600">* Chia sẻ ý tưởng của bạn với cộng đồng.</p>
           </div>
           
           <div className="border-b-2 border-black mb-8"></div>

           <div className="mb-6">
               <label className="font-mono text-sm uppercase font-bold mb-2 block">TIÊU ĐỀ BÀI VIẾT <span className="text-neo-primary">&lt;STRING&gt;</span></label>
               <input className="w-full bg-transparent text-xl font-bold border-none focus:ring-0 placeholder:text-gray-300 p-0" placeholder="Nhập tiêu đề..." />
           </div>

           <div className="mb-6 flex-1">
               <label className="font-mono text-sm uppercase font-bold mb-2 block">NỘI DUNG <span className="text-neo-primary">&lt;TEXT&gt;</span></label>
               <textarea 
                className="w-full h-64 border-2 border-black p-4 font-mono focus:shadow-hard transition-shadow resize-none"
                placeholder="Bắt đầu viết ở đây..."
               ></textarea>
           </div>

           <div className="mb-8">
                <label className="font-mono text-sm uppercase font-bold mb-2 block">THÊM TAGS <span className="text-neo-primary">&lt;ARRAY&gt;</span></label>
                <div className="flex flex-wrap gap-3">
                    {['neobrutalism', 'design', 'uiux', 'tech'].map(tag => (
                        <div key={tag} className="border-2 border-black px-3 py-1 font-mono text-sm font-bold shadow-hard-sm bg-white">
                            {tag}
                        </div>
                    ))}
                    <button className="border-2 border-black border-dashed px-3 py-1 font-mono text-sm text-gray-500 hover:bg-gray-100 flex items-center gap-1">
                        <Plus size={14} /> Add New
                    </button>
                </div>
           </div>

           <div className="mb-8">
                <label className="font-mono text-sm uppercase font-bold mb-2 block">CÀI ĐẶT RIÊNG TƯ <span className="text-neo-primary">&lt;ENUM&gt;</span></label>
                <div className="flex gap-6 font-mono text-sm">
                    <label className="flex items-center gap-2 cursor-pointer">
                        <div className="w-5 h-5 border-2 border-black bg-neo-primary flex items-center justify-center">
                            <div className="w-2 h-2 bg-white rounded-full"></div>
                        </div>
                        Công khai
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer">
                         <div className="w-5 h-5 border-2 border-black bg-white"></div>
                        Chỉ mình tôi
                    </label>
                    <label className="flex items-center gap-2 cursor-pointer">
                        <div className="w-5 h-5 border-2 border-black bg-white"></div>
                        Bạn bè
                    </label>
                </div>
           </div>
           
           <div className="border-t-2 border-black pt-6 flex justify-end">
               <NeoButton size="lg" className="w-full md:w-auto">ĐĂNG BÀI</NeoButton>
           </div>
       </NeoCard>
    </div>
  );
};
